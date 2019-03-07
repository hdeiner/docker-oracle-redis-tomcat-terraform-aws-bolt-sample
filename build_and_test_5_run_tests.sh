#!/usr/bin/env bash

figlet -f standard "Run Tests"

export RUNBATCH=$(echo `cat ./.runbatch`)
export REDIS=$(echo `cat ./.redis_dns`)
export ORACLE=$(echo `redis-cli -h $REDIS get $USER.$RUNBATCH.oracle.dns`)
export TOMCAT=$(echo `redis-cli -h $REDIS get $USER.$RUNBATCH.tomcat.dns`)

echo "REDIS at "$REDIS
echo "ORACLE at "$ORACLE
echo "TOMCAT at "$TOMCAT

echo Smoke test
echo "curl -s http://$TOMCAT:8080/passwordAPI/passwordDB"
curl -s http://$TOMCAT:8080/passwordAPI/passwordDB > temp
if grep -q "RESULT_SET" temp
then
    echo "SMOKE TEST SUCCESS"
    figlet -f slant "Smoke Test Success"

    echo "Configuring test application to point to Tomcat endpoint"
    echo "hosturl=http://$TOMCAT:8080" > rest_webservice.properties

    echo "Run integration tests"
    mvn -q verify failsafe:integration-test
else
    echo "SMOKE TEST FAILURE!!!"
    figlet -f slant "Smoke Test Failure"
fi
rm temp