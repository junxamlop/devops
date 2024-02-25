FROM php:8.2-apache

RUN rm -rf /var/www/html/*

COPY src /var/www/html

EXPOSE 8080

