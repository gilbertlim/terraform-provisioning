# 파일 시스템 사용량 확인
df - h

# 연결된 디스크 목록 확인
lsblk

# 파티션 생성
fdisk /dev/xvdf
# 포맷
mkfs -t xfs /dev/xvdf1

# 마운트할 디렉토리 생성
mkdir /data

# 마운트
mount dev/xvdf1 /data
df -h

# 자동 마운트 설정 (재부팅 시)
sudo blkid # UUID="@@@" 복사
sudo vi /etc/fstab
# UUID="@@@" /data 입력
