#!/usr/bin/env bash

figlet -f standard "Provision Oracle and Tomcat"

export RUNBATCH=$(echo `cat ./.runbatch`)
export REDIS=$(echo `cat ./.redis_dns`)
export ORACLE=$(echo `redis-cli -h $REDIS get $USER.$RUNBATCH.oracle.dns`)
export TOMCAT=$(echo `redis-cli -h $REDIS get $USER.$RUNBATCH.tomcat.dns`)

echo "REDIS at "$REDIS
echo "ORACLE at "$ORACLE
echo "TOMCAT at "$TOMCAT

echo "Provision Oracle"
bolt file upload 'provision_oracle.sh' '/home/ubuntu/provision_oracle.sh' --nodes $ORACLE --user 'ubuntu' --no-host-key-check
bolt command run 'chmod +x /home/ubuntu/provision_oracle.sh' --nodes $ORACLE --user 'ubuntu' --no-host-key-check
bolt command run '/home/ubuntu/provision_oracle.sh' --nodes $ORACLE --user 'ubuntu' --no-host-key-check

redis-cli -h $REDIS set $USER.$RUNBATCH.oracle.user system
redis-cli -h $REDIS set $USER.$RUNBATCH.oracle.password oracle

export ORACLEUSER=$(echo `redis-cli -h $REDIS get $USER.$RUNBATCH.oracle.user`)
export ORACLEPASSWORD=$(echo `redis-cli -h $REDIS get $USER.$RUNBATCH.oracle.password`)

echo "Build the liquibase.properties file for Liquibase to run against"
echo "driver: oracle.jdbc.driver.OracleDriver" > liquibase.properties
echo "classpath: lib/ojdbc8.jar" >> liquibase.properties
echo "url: jdbc:oracle:thin:@$ORACLE:1521:xe" >> liquibase.properties
echo "username: "$ORACLEUSER >> liquibase.properties
echo "password: "$ORACLEPASSWORD >> liquibase.properties

echo "Create database schema and load sample data"
liquibase --changeLogFile=src/main/db/changelog.xml update

echo "Build fresh war for Tomcat deployment"
mvn -q clean compile war:war

echo "Build the oracleConfig.properties files for Tomcat war to run with"
echo "url=jdbc:oracle:thin:@$ORACLE:1521/xe" > oracleConfig.properties
echo "user="$ORACLEUSER >> oracleConfig.properties
echo "password="$ORACLEPASSWORD >> oracleConfig.properties

echo "Provision Tomcat"
bolt file upload 'provision_tomcat.sh' '/home/ubuntu/provision_tomcat.sh' --nodes $TOMCAT --user 'ubuntu' --no-host-key-check
bolt command run 'chmod +x /home/ubuntu/provision_tomcat.sh' --nodes $TOMCAT --user 'ubuntu' --no-host-key-check
bolt file upload 'oracleConfig.properties' '/home/ubuntu/oracleConfig.properties' --nodes $TOMCAT --user 'ubuntu' --no-host-key-check
bolt file upload 'target/passwordAPI.war' '/home/ubuntu/passwordAPI.war' --nodes $TOMCAT --user 'ubuntu' --no-host-key-check
bolt command run '/home/ubuntu/provision_tomcat.sh' --nodes $TOMCAT --user 'ubuntu' --no-host-key-check