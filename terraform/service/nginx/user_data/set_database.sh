# docker
sudo yum install docker -y
sudo service docker start

# sudo docker pull mariadb

# docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 파티션 확인
df -h # /data

# docker cli
sudo docker run \
    --name mariadb \
    -d \
    -p 3306:3306 \
    --restart=always \
    -e MYSQL_ROOT_PASSWORD=root \
    --mount type=bind,source=/data/mariadb,target=/var/lib/mysql \
    mariadb

# docker-compose
sudo docker-compose up

# 로그인
docker exec -it mariadb /bin/bash
mysql -u root -p

# db 초기 설정
create database api_status;



<<'#comment'
# mariadb에서 실제 db경로 확인
select @@datadir; # /var/lib/mysql/ 

# 데이터 복사
rsync -av /var/lib/mysql /data/mariadb

show databases;
#comment
