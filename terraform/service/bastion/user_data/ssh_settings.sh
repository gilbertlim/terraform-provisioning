sudo echo -e "Port 5299\nPermitRootLogin no" >> /etc/ssh/sshd_config
sudo vi ~/.ssh/authorized_keys # 개인키 저장
sudo service sshd restart

# ec2-user sudo 권한 제거
# sudo visudo -f /etc/sudoers.d/90-cloud-init-users ---> ec2-user 주석 처리 혹은 파일 삭제