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
