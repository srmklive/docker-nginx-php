FROM srmklive/docker-ubuntu:latest

LABEL maintainer="Raza Mehdi<srmk@outlook.com>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get -y upgrade

RUN add-apt-repository ppa:nginx/stable \
  && add-apt-repository ppa:ondrej/php \
  && curl -sL https://deb.nodesource.com/setup_lts.x | bash - \
  && apt-get update && apt-get -y upgrade

RUN apt-get -y install nodejs && npm install -g npm && npm install -g yarn

RUN apt-get -y install nginx \
  php8.1-fpm php8.1-cli php8.1-curl php8.1-mbstring \
  php8.1-mysql php8.1-pgsql php8.1-gd php8.1-bcmath php8.1-readline \
  php8.1-zip php8.1-imap php8.1-xml php8.1-intl php8.1-soap \
  php8.1-memcached php8.1-xdebug php8.1-redis

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
  && php composer-setup.php --install-dir=/usr/bin --filename=composer \
  && php -r "unlink('composer-setup.php');"

RUN apt-get -y autoclean \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
