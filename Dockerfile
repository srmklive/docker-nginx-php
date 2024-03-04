FROM srmklive/docker-ubuntu:20.04

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
  php5.6-fpm php5.6-cli php5.6-curl php5.6-mbstring php5.6-json \
  php5.6-mysql php5.6-pgsql php5.6-gd php5.6-bcmath php5.6-readline \
  php5.6-zip php5.6-imap php5.6-xml php5.6-json php5.6-intl php5.6-soap \
  php5.6-memcached php5.6-xdebug php5.6-redis

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
  && php composer-setup.php --2.2 --install-dir=/usr/bin --filename=composer \
  && php -r "unlink('composer-setup.php');"

RUN npm i npm@latest -g \
  && yarn --global install \
  && yarn --global upgrade

RUN apt-get -y autoclean \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
