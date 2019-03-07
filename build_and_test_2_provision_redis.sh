#!/usr/bin/env bash

figlet -f standard "Provision Redis"

export REDIS=$(echo `cat ./.redis_dns`)
echo "REDIS at "$REDIS

bolt file upload 'provision_redis.sh' '/home/ubuntu/provision_redis.sh' --nodes $REDIS --user 'ubuntu' --no-host-key-check
bolt command run 'chmod +x /home/ubuntu/provision_redis.sh' --nodes $REDIS --user 'ubuntu' --no-host-key-check
bolt command run '/home/ubuntu/provision_redis.sh' --nodes $REDIS --user 'ubuntu' --no-host-key-check