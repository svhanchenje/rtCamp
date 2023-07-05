#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Installing Docker..."
    # Install Docker
    sudo yum update -y
    sudo yum install -y docker
    sudo service docker start
    sudo usermod -aG docker ec2-user
    echo "Docker installed and started successfully."
else
    echo "Docker is already installed."
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose not found. Installing Docker Compose..."
    # Install Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "Docker Compose installed successfully."
else
    echo "Docker Compose is already installed."
fi


# Create a Dockerfile

cat <<EOF > Dockerfile
services:
  web:
    image: nginx:latest
    ports:
      - 80:80
    volumes:
      - ./web:/var/www/html
      - ./nginx/conf.d:/etc/nginx/conf.d
    depends_on:
      - php

  db:
    image: mysql:latest
    environment:
       MYSQL_ROOT_PASSWORD: Pass@123
       MYSQL_DATABASE: wordpressdb
    ports:
      - 3306
    volumes:
      - ./mysql/data:/var/lib/mysql

  php:
    image: php:latest
    volumes:
      - ./web:/var/www/html

  wordpress:
        image: wordpress:latest
        ports:
         - 8080:80
        volumes:
         - ./wordpress:/var/www/html
        environment:
             WORDPRESS_DB_HOST: db
             WORDPRESS_DB_USER: root
             WORDPRESS_DB_PASSWORD: Pass@123
             WORDPRESS_DB_NAME: wordpressdb
        depends_on:
         - db
EOF


# For Docker-compose file run
  sudo SITE_NAME=example.com docker-compose -f Dockerfile up -d
