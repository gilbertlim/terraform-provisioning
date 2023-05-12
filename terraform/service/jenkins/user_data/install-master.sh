#!/bin/bash
# https://blog.illunex.com/201207-2
# https://doing7.tistory.com/120
sudo yum -y update
sudo yum -y install java-11-amazon-corretto.x86_64
# sudo alternatives --config java
sudo yum -y install git

sudo yum -y install deltarpm
sudo yum -y update yum.noarch
# 속도가 느릴 때 clean 후 다시 사용
sudo yum clean all

sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum -y install jenkins
# sed -i 's/JENKINS_PORT="8080"/JENKINS_PORT="9090"/g' /etc/sysconfig/jenkins

sudo service jenkins start





# master + slave 구성
ssh-keygen