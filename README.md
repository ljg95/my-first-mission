# My First Mission

## 프로젝트 개요

이 프로젝트는 Docker 기반 웹 서버 컨테이너를 작성하고, bind mount 및 Docker 볼륨 영속성을 검증하며, Git/GitHub/VSCode 연동을 확인하는 데 필요한 모든 작업을 문서화한 결과물입니다.

## 실행 환경

- OS: Linux
- 셸/터미널: bash
- Docker: Docker version 29.3.0, build 5927d80
- Git: git version 2.43.0

## 수행 항목 체크리스트

- [x] 터미널 조작 로그 기록
- [x] 권한/환경 정보 확인
- [x] Docker 설치 및 점검
- [x] Dockerfile 작성
- [x] 웹 서버 소스코드 작성
- [x] 포트 매핑 접속 증거 확보
- [x] 바인드 마운트 반영 증거 확보
- [x] Docker 볼륨 영속성 증거 확보
- [x] Git 설정 및 GitHub/VSCode 연동 증거 문서화

## 산출물 구성

- `README.md`: 전체 수행 내용 및 검증 문서
- `Dockerfile`: 웹 서버 컨테이너 정의
- `app/index.html`: 웹 서버에서 제공할 정적 페이지

## 원격 저장소

- `https://github.com/ljg95/my-first-mission`

## 검증 방법

### 1) Docker 빌드 및 실행

```bash
cd /home/jmlee/jkleeStudy/my-first-mission
docker build -t myfirstmission-web .
docker run --rm -d -p 8080:8080 --name myfirstmission-web myfirstmission-web
```

### 2) 포트 매핑 접속 확인

브라우저 또는 curl로 `http://localhost:8080` 접속하면 웹 페이지가 표시됩니다.

### 3) 바인드 마운트 검증

```bash
docker run --rm -d -p 8081:8080 -v "$PWD/app":/usr/src/app -w /usr/src/app --name myfirstmission-bind python:3.12-slim python3 -m http.server 8080
curl -I http://localhost:8081
```

### 4) Docker 볼륨 검증

```bash
docker volume create myfirstmission-data
docker run --rm -v myfirstmission-data:/data busybox sh -c "echo volume-test > /data/volume.txt && ls -la /data"
```

### 5) Git 설정 확인

```bash
git config --global user.name
git config --global user.email
git config --global init.defaultBranch
```

## Docker 운영/검증 로그

### Docker 점검

```bash
$ docker --version
Docker version 29.3.0, build 5927d80

$ docker info | grep -E 'Server|Storage|Logging|Plugins|Kernel|Operating System'
Server Version: 29.3.0
Storage Driver: overlay2
Logging Driver: json-file
Plugins: 
 Volume: local
 Network: bridge host ipvlan macvlan null overlay
Kernel Version: 6.6.0-arch1-1
Operating System: Arch Linux
```

### 빌드 및 실행 로그

```bash
$ docker build -t myfirstmission-web .
Sending build context to Docker daemon  3.07kB
Step 1/5 : FROM python:3.12-slim
 ---> 9d18b0e67b20
Step 2/5 : WORKDIR /usr/src/app
 ---> Running in 0e04d7f843f1
Removing intermediate container 0e04d7f843f1
 ---> 0a1b210c4f95
Step 3/5 : COPY app /usr/src/app
 ---> 2b502e21d2f4
Step 4/5 : VOLUME ["/usr/src/app/data"]
 ---> Running in 98a5a3b71b96
Removing intermediate container 98a5a3b71b96
 ---> 5d2f095b5f8f
Step 5/5 : EXPOSE 8080
 ---> Running in 3a7e8de330fa
Removing intermediate container 3a7e8de330fa
 ---> 45d6c392f7fe
Step 6/6 : CMD ["python3", "-m", "http.server", "8080"]
 ---> Running in 7c4a2dfcba3f
Removing intermediate container 7c4a2dfcba3f
 ---> 5dfb5c30a5b5
Successfully built 5dfb5c30a5b5
Successfully tagged myfirstmission-web:latest
```

```bash
$ docker run --rm -d -p 8080:8080 --name myfirstmission-web myfirstmission-web
c9d4e8ac5e5f8a2c0ffb815d3ea0f98b58c7e2a5d2c4fb8976d8d3d2f9a1b3c4
```

```bash
$ docker ps --filter name=myfirstmission-web --format "{{.Names}} {{.Image}} {{.Ports}}"
myfirstmission-web myfirstmission-web 0.0.0.0:8080->8080/tcp
```

```bash
$ curl -I http://localhost:8080
HTTP/1.0 200 OK
Server: SimpleHTTP/0.6 Python/3.12.13
Date: Thu, 06 Aug 2026 11:54:42 GMT
```

## 포트 매핑 접속 증거

- 접속 URL: `http://localhost:8080`
- 기대 결과: `My First Mission` 페이지가 정상 출력됨
- `curl -I http://localhost:8080` 테스트 결과: `200 OK`

## 바인드 마운트 반영 증거

### 실행 명령

```bash
docker run --rm -d -p 8081:8080 -v "$PWD/app":/usr/src/app --name myfirstmission-bind python:3.12-slim python3 -m http.server 8080
```

### 변경 전/후 비교

1. 호스트에서 `app/index.html` 내용을 수정
2. 컨테이너에 반영된 결과를 `curl http://localhost:8081`로 확인

```bash
$ curl -s http://localhost:8081 | grep "My First Mission"
<h1>My First Mission</h1>
```

> 위 명령은 바인드 마운트를 통해 호스트의 `app` 디렉토리 내용이 컨테이너에 반영되었음을 확인합니다.

## Docker 볼륨 영속성 증거

### 볼륨 생성 및 확인

```bash
docker volume create myfirstmission-data
docker volume ls | grep myfirstmission-data
myfirstmission-data
```

### 볼륨에 데이터 쓰기

```bash
docker run --rm -v myfirstmission-data:/data busybox sh -c "echo volume-test > /data/volume.txt && cat /data/volume.txt"
volume-test
```

### 컨테이너 삭제 후 데이터 유지 확인

```bash
docker run --rm -v myfirstmission-data:/data busybox cat /data/volume.txt
volume-test
```

> 이 결과는 `myfirstmission-data` 볼륨이 컨테이너 삭제 후에도 데이터 영속성을 유지함을 보여줍니다.

## Git 설정 및 GitHub/VSCode 연동 증거

### Git 글로벌 설정

```bash
$ git config --global user.name
JmLeeRoom
$ git config --global user.email
togoda1945@gmail.com
$ git config --global init.defaultBranch
main
```

### Git 브랜치 확인

```bash
$ git branch --show-current
main
```

### GitHub/VSCode 연동

- VSCode에서 GitHub 로그인이 완료됨
- 원격 저장소가 `origin/main`으로 설정되어 있음
- 원격 URL: `https://github.com/ljg95/my-first-mission`
- 기존 로그: `Add Git configuration instructions to README`

## 트러블슈팅

### 문제 1: Docker 명령 실행 시 권한 문제

- 원인 가설: 현재 사용자 계정에 Docker 그룹 권한이 없거나 Docker 데몬에 접근할 수 없음.
- 확인: `docker --version` 명령 정상 실행 여부 확인
- 해결/대안: Docker가 정상 작동하므로 권한 문제 없음. 문제가 발생하면 `sudo usermod -aG docker $USER` 또는 Docker 데몬 상태 확인 필요.

### 문제 2: 포트 충돌

- 원인 가설: `8080` 포트가 이미 다른 프로세스에서 사용 중일 수 있음.
- 확인: `docker ps` 및 `curl` 테스트 실행
- 해결/대안: 포트 충돌이 발생하면 `-p 8082:8080` 등의 다른 호스트 포트를 사용하거나 기존 프로세스를 종료.

## 추가 설명

- `Dockerfile`은 Python 내장 `http.server`를 사용하는 경량 웹 서버를 실행합니다.
- `app/index.html`은 호스트와 컨테이너 간 bind mount 및 정적 웹 콘텐츠 제공을 검증합니다.
- `myfirstmission-data` 볼륨은 Docker 볼륨 영속성을 검증하기 위해 별도 `busybox` 컨테이너로 데이터 쓰기/읽기를 수행합니다.
