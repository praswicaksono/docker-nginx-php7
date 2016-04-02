FROM ubuntu:latest

RUN export LANG=C.UTF-8 && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:nginx/stable && \
    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y && \
    apt-get update && \
    apt-get install -y nginx php7.0-fpm python-pip && \
    apt-get install -y php7.0-pgsql php7.0-mcrypt php7.0-intl php7.0-curl php7.0-gd && \
    pip install supervisor && \
    rm -rf /var/lib/apt/lists/*

RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN chown -R www-data:www-data /var/lib/nginx

# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Define working directory.
WORKDIR /etc/nginx

ADD docker/nginx/sites-available/default /etc/nginx/sites-available
ADD docker/supervisord.conf /etc/supervisord.conf
RUN mkdir /run/php && chown www-data:www-data /run/php

# Define default command.
CMD supervisord -c /etc/supervisord.conf

# Expose ports.
EXPOSE 80
EXPOSE 443
