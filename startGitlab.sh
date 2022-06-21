#!/bin/bash

dir=$(pwd)
GITLAB_HOME=${dir}/gitlab

mkdir -p ${GITLAB_HOME}

docker run --detach \
  --hostname gitlab.local \
  --publish 443:443 --publish 80:80 --publish 22:22 \
  --name gitlab \
  --restart always \
  --volume $GITLAB_HOME/config:/etc/gitlab \
  --volume $GITLAB_HOME/logs:/var/log/gitlab \
  --volume $GITLAB_HOME/data:/var/opt/gitlab \
  --shm-size 256m \
  --network bridge \
  gitlab/gitlab-ee:latest

docker ps gitlab

docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password   

docker volume create gitlab-runner-config

docker run -d --name gitlab-runner --restart always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v gitlab-runner-config:/etc/gitlab-runner \
    --network bridge \
    gitlab/gitlab-runner:latest