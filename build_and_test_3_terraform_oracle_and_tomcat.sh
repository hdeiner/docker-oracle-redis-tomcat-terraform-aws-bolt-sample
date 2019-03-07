#!/usr/bin/env bash

figlet -f standard "Terraform Oracle and Tomcat"

cd terraform-oracle-tomcat
terraform init
terraform apply -auto-approve
echo `terraform output oracle_dns` > ../.oracle_dns
echo `terraform output tomcat_dns` > ../.tomcat_dns
cd ..

export REDIS=$(echo `cat ./.redis_dns`)
export ORACLE=$(echo `cat ./.oracle_dns`)
export TOMCAT=$(echo `cat ./.tomcat_dns`)

echo "REDIS at "$REDIS
echo "ORACLE at "$ORACLE
echo "TOMCAT at "$TOMCAT

echo `date +%Y%m%d%H%M%S` > ./.runbatch
export RUNBATCH=$(echo `cat ./.runbatch`)

redis-cli -h $REDIS set $USER.$RUNBATCH.oracle.dns $ORACLE
redis-cli -h $REDIS set $USER.$RUNBATCH.tomcat.dns $TOMCAT