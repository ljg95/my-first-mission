FROM python:3.12-slim
WORKDIR /usr/src/app
COPY app /usr/src/app
VOLUME ["/usr/src/app/data"]
EXPOSE 8080
CMD ["python3", "-m", "http.server", "8080"]
