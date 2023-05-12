# terraform-provisioning


# Integrated Service
## 1. Bastion
Bastion을 통한 Database 터널링

## 2. Front Desk
Bastion Authentication/Authorization 서비스

Slack Custom App 생성 후 App이 integrate된 채널에서 지정된 command와 ip(`/opensesame nginx 82.100.52.99`)를 입력하면 Bastion Security Group Inbound Rule에 입력한 IP가 등록된다.

Bastion을 항상 열어두는 것이 아니라 Slack Channel에 존재하는 사람만이 Bastion에 접속할 수 있도록 하기 위해 서비스를 구현 했다.

사용 방법

1. slack channel에서 본인의 고정 IP Open 요청
2. 터널링 수행
`ssh -i ./media-platform-bastion-key.pem -p 5299 ec2-user@bastion-1team.gilbert.com \
-fNL 13306:nginx.media-platform.internal:3306`
3. `nginx.media-platform.internal:3306` 으로 DB 접속

# Further Goals
- jenkins로 Nginx 배포
  - Nginx
  - Fluent-bit


# Maintenance

장기 미사용 시
- nat 삭제
- ec2 삭제
  - nginx, jenkins
- alb 삭제
  - nginx, jenkins
- route53 삭제


중지 시
- nat 삭제
- ec2 중지
  - nginx, jenkins