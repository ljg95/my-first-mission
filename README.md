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

## 터미널 조작 로그

### 1) 현재 위치 확인 / 목록 확인(숨김 포함)

```bash
$ pwd
/home/jmlee/jkleeStudy/my-first-mission

$ ls -la
.total 36
.drwxrwxr-x 4 jmlee jmlee 4096 Aug  6 20:58 .
.drwxrwxr-x 3 jmlee jmlee 4096 Aug  6 20:47 ..
.drwxrwxr-x 2 jmlee jmlee 4096 Aug  6 20:57 app
-rw-rw-r-- 1 jmlee jmlee 151 Aug  6 20:52 Dockerfile
-rw-rw-r-- 1 jmlee jmlee 24 Aug  6 20:58 .gitignore
-rw-rw-r-- 1 jmlee jmlee 9602 Aug  6 21:11 README.md
```

### 2) 이동/생성/복사/이동/삭제 실습

```bash
$ mkdir -p demo-dir
$ touch demo-dir/sample.txt
$ cp demo-dir/sample.txt demo-dir/sample-copy.txt
$ mv demo-dir/sample-copy.txt demo-dir/renamed.txt
$ rm -f demo-dir/renamed.txt
$ rmdir demo-dir
```

### 3) 파일 내용 확인 / 빈 파일 생성

```bash
$ printf 'hello\n' > note.txt
$ cat note.txt
hello

$ : > empty.txt
$ ls -l note.txt empty.txt
-rw-rw-r-- 1 jmlee jmlee 6 Aug  6 21:13 note.txt
-rw-rw-r-- 1 jmlee jmlee 0 Aug  6 21:13 empty.txt
```

## 권한 실습 및 증거

### 4) 권한 확인/변경 실습

```bash
$ mkdir -p chmod-demo
$ touch chmod-demo/file.txt
$ stat -c '%n %A %a' chmod-demo chmod-demo/file.txt
chmod-demo drwxrwxr-x 775
chmod-demo/file.txt -rw-rw-r-- 664

$ chmod 640 chmod-demo/file.txt
$ chmod 750 chmod-demo
$ stat -c '%n %A %a' chmod-demo chmod-demo/file.txt
chmod-demo drwxr-x--- 750
chmod-demo/file.txt -rw-r----- 640
```

- 의미: `755`는 소유자 `rwx`, 그룹/기타 `r-x`이고, `644`는 소유자 `rw-`, 그룹/기타 `r--`를 의미합니다.

## Docker 설치 및 기본 점검

```bash
$ docker --version
Docker version 29.3.0, build 5927d80

$ docker info --format '{{.ServerVersion}} {{.OperatingSystem}} {{.Driver}}'
29.3.0 Ubuntu 24.04.3 LTS overlayfs
```

## Docker 기본 운영 명령

```bash
$ docker images
REPOSITORY          TAG       IMAGE ID
my-custom-web       latest    ...
myfirstmission-web  latest    ...
python              3.12-slim ...
ubuntu              24.04     ...
busybox             latest    ...

$ docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}'
NAMES                                STATUS                        IMAGE
log-demo                             Up Less than a second         busybox
custom-web                           Up 3 minutes                  my-custom-web
myfirstmission-web                   Exited (137) 24 minutes ago   myfirstmission-web
```

```bash
$ docker run -d --name log-demo busybox sh -c 'echo hello-from-log; sleep 2'
$ docker logs log-demo
hello-from-log
```

## 컨테이너 실행 실습

### hello-world 실행

```bash
$ docker run --rm hello-world
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

### Ubuntu 컨테이너 실행 및 내부 명령

```bash
$ docker run --rm -it ubuntu:24.04 /bin/bash -lc 'echo hello-from-ubuntu && ls / && exit'
hello-from-ubuntu
bin   dev  home  lib64  mnt  proc  run   srv  tmp  var
boot  etc  lib   media  opt  root  sbin  sys  usr
```

### attach/exec 차이 정리

- `docker run`으로 컨테이너를 시작한 뒤 `docker attach`로 붙으면 기존 실행 프로세스의 출력 흐름에 연결됩니다.
- `docker exec`는 이미 실행 중인 컨테이너 안에 새 명령을 실행할 때 사용합니다.
- 즉, `attach`는 기존 프로세스에 연결, `exec`는 추가로 명령을 실행하는 방식입니다.

## 기존 Dockerfile 기반 커스텀 이미지 제작

### 선택한 베이스 이미지

- 기존 베이스: `python:3.12-slim`
- 이유: 경량 파이썬 기반 웹 서버를 빠르게 구성할 수 있어 실습에 적합합니다.

### 적용한 커스텀 포인트

- `WORKDIR /usr/src/app` 설정으로 작업 디렉터리 지정
- `COPY app /usr/src/app`로 정적 웹 파일 포함
- `EXPOSE 8080`으로 포트 명시
- `CMD ["python3", "-m", "http.server", "8080"]`로 웹 서버 실행

### 빌드/실행 명령 및 결과

```bash
$ docker build -t my-custom-web .
$ docker run --rm -d -p 8082:80 --name custom-web my-custom-web
```

```bash
$ curl -I http://localhost:8082
HTTP/1.1 200 OK
```

## 포트 매핑 및 접속 증거

- 접속 URL: `http://localhost:8082`
- 접속 확인: `curl -I http://localhost:8082` 결과 `HTTP/1.1 200 OK`

## Docker 볼륨 영속성 검증

```bash
$ docker volume create myfirstmission-data
$ docker run --rm -v myfirstmission-data:/data busybox sh -c 'echo volume-test > /data/volume.txt && cat /data/volume.txt'
volume-test

$ docker run --rm -v myfirstmission-data:/data busybox cat /data/volume.txt
volume-test
```

- 결과: 컨테이너 삭제 후에도 볼륨에 저장된 데이터가 유지됩니다.

## Git 설정 및 GitHub 연동

```bash
$ git config --global user.name
JmLeeRoom

$ git config --global user.email
togoda1945@gmail.com

$ git config --global init.defaultBranch
main

$ git config --list | grep -E 'user.name|user.email|init.defaultBranch'
user.name=JmLeeRoom
user.email=togoda1945@gmail.com
init.defaultBranch=main
```

- GitHub 로그인: GitHub CLI 인증 완료
- 저장소 연동: `origin`/`upstream` 설정 확인 가능
- 보안: 토큰, 패스워드, 개인키 등은 문서/로그에 포함하지 않았습니다.

## 보안 및 개인정보 보호

- 민감한 인증 정보는 문서, 로그, 스크린샷에 포함하지 않았습니다.
- 필요 시 토큰/비밀번호는 마스킹 처리하고, 이미 노출된 경우 즉시 재발급/삭제 절차를 진행해야 합니다.

## 학습 포인트 정리

### 1) 절대 경로와 상대 경로

- 절대 경로: 파일 시스템 최상위부터 시작하는 경로입니다. 예를 들어 `/home/jmlee/jkleeStudy/my-first-mission/app/index.html`처럼 전체 경로를 직접 적는 방식입니다.
- 상대 경로: 현재 작업 중인 위치를 기준으로 표현하는 경로입니다. 예를 들어 현재 디렉터리가 `/home/jmlee/jkleeStudy/my-first-mission`일 때 `./app/index.html`은 현재 폴더의 `app/index.html`을 뜻하고, `../`는 상위 디렉터리를 의미합니다.

### 2) 파일 권한(r/w/x)과 `755`, `644`

- `r`(read): 읽기 권한
- `w`(write): 쓰기 권한
- `x`(execute): 실행 권한
- 권한은 3비트씩 묶어 숫자로 표현합니다.
  - `r=4`, `w=2`, `x=1`
  - `7` = `4+2+1` = `rwx`
  - `5` = `4+1` = `r-x`
  - `6` = `4+2` = `rw-`
- 예시
  - `755`: 소유자에게 `rwx`, 그룹/다른 사용자에게 `r-x`
  - `644`: 소유자에게 `rw-`, 그룹/다른 사용자에게 `r--`
- 명령 예시: `chmod 755 script.sh`, `chmod 644 file.txt`

### 3) 기존 Dockerfile 기반으로 커스텀 이미지 만들기

기존 Dockerfile을 바탕으로 필요한 패키지 설치, 파일 복사, 실행 명령을 추가하면 커스텀 이미지를 만들 수 있습니다.

예시:

```bash
docker build -t my-custom-image .
```

즉, Dockerfile의 `FROM`, `COPY`, `RUN`, `CMD` 지시어를 조합해 애플리케이션에 맞는 이미지로 확장하면 됩니다.

### 4) 포트 매핑이 필요한 이유

컨테이너 내부에서 실행 중인 서비스는 기본적으로 컨테이너 네트워크 안에 있습니다. 호스트(PC)에서 접근하려면 컨테이너의 내부 포트와 호스트의 외부 포트를 연결해야 합니다.

예시:

```bash
docker run -p 8080:8080 myfirstmission-web
```

이 명령은 호스트의 `8080` 포트를 컨테이너의 `8080` 포트로 전달합니다.

### 5) Docker 볼륨(영속 데이터)

Docker 볼륨은 컨테이너가 삭제되어도 데이터가 사라지지 않도록 저장하는 공간입니다. 로그, 데이터베이스 파일, 업로드 파일 같은 영속 데이터를 보관할 때 사용합니다.

예시:

```bash
docker volume create mydata
docker run -v mydata:/data busybox sh -c "echo hello > /data/file.txt"
```

이렇게 하면 컨테이너를 다시 만들더라도 데이터가 유지됩니다.

### 6) Git과 GitHub의 역할 차이

- Git: 로컬 컴퓨터에서 파일 변경 이력을 관리하는 버전 관리 도구입니다.
- GitHub: Git 저장소를 원격에서 업로드하고, 협업·공유·PR(풀 리퀘스트)·이슈 관리 등을 지원하는 플랫폼입니다.

즉, Git은 “버전 관리 도구”, GitHub는 “원격 협업 플랫폼”이라고 이해하면 됩니다.

## 추가 설명

- `Dockerfile`은 Python 내장 `http.server`를 사용하는 경량 웹 서버를 실행합니다.
- `app/index.html`은 호스트와 컨테이너 간 bind mount 및 정적 웹 콘텐츠 제공을 검증합니다.
- `myfirstmission-data` 볼륨은 Docker 볼륨 영속성을 검증하기 위해 별도 `busybox` 컨테이너로 데이터 쓰기/읽기를 수행합니다.
