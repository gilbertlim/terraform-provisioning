#!/bin/bash
sudo yum -y update
sudo yum install -y java-11-amazon-corretto.x86_64
sudo yum -y install git
sudo yum -y install docker
sudo yum -y install sshd

sudo amazon-linux-extras install ansible2 -y

sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install packer
sudo yum -y install jq

# 이미 설치된 packer가 있으므로 삭제후 hashicorp의 packer 심볼릭 링크 적용해야함
sudo rm -rf /sbin/packer
sudo ln -s /usr/bin/packer /sbin/packer

# master + slave 구성
# vi ~/.ssh/authorized_keys : master의 pub key 등록
