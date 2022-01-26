# Sample Golang Application


## Overview
- Dockerized. Change the environment variables if need be inside Dockerfile ENV sections
- Sends a message every 5 seconds
- `docker build --tag mq-golang-put-interval .`
- `docker run -p 8080:8080 mq-golang-put-interval`