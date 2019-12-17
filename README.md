# phiremock-docker
Simple docker container for phiremock

## Install

```bash
docker build -t phiremock:latest .
```

## Use

```bash
docker run -ti --rm phiremock 
```

## Example docker-compose.yml configuration

```yml
# Assumes following structure:
# /
# /compose.json
# /bin
# /public
# /src
# /more-application-folders
# /docker/config/nginx/Dockerfile
# /docker/config/mysql/Dockerfile
# /docker/config/phiremock/Dockerfile
# /docker/config/codeception/Dockerfile
# /docker/config/php/Dockerfile
# /tests/_data/expectations
# /tests/_output
# /tests/_support
# /tests/acceptance
# /tests/acceptance.suite.yml

version: "3.2"

services:
  my-project-web-server:
    build: docker/config/nginx/
    image: my-project-webserver-image
    volumes:
      - .:/var/www/html:cached
    networks:
      - my-project_app_internal

  mysql-db:
    build: docker/config/mysql/
    image: my-project-mysql-db-image
    volumes:
      - type: volume
        source: db-data
        target: /var/lib/mysql
        consistency: cached
    environment:
      - MYSQL_ROOT_PASSWORD=docker
      - MYSQL_USER=dockeruser
      - MYSQL_PASSWORD=dockerpass
    networks:
      - my-project_app_internal

  mongo-db:
    image: mongo:3.4-xenial
    restart: always
    environment:
      - MONGO_INITDB_ROOT_USERNAME=root
      - MONGO_INITDB_ROOT_PASSWORD=docker
    networks:
      - my-project_app_internal

  elastic:
    image: elasticsearch:6.8.3
    networks:
      - my-project_app_internal
    environment:
      - "discovery.type=single-node"

  my-project-app:
    build: docker/config/php
    image: my-project-app-image
    volumes:
      - .:/var/www/html:cached
    networks:
      - my-project_app_internal
    environment:
      - APPLICATION_ENV=acceptance

  phiremock:
    build: docker/config/phiremock
    image: my-project-phiremock-image
    volumes:
      - ./tests/_data/expectations:/opt/phiremock/expectation-files:cached
    networks:
      - my-project_app_internal

  codecept:
    build: docker/config/codeception
    image: my-project-codeception-image
    depends_on:
      - my-project-app
      - my-project-web-server
      - mongo-db
      - mysql-db
      - phiremock
      - elastic
    volumes:
      - .:/project
    networks:
      - my-project_app_internal

volumes:
  db-data:

networks:
  my-project_app_internal:
    driver: bridge
```
