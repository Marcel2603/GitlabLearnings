#!/bin/bash

docker-compose up -d
sleep 120
docker-compose exec gitlab grep 'Password:' /etc/gitlab/initial_root_password   