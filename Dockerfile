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
  php7.2-fpm php7.2-cli php7.2-curl php7.2-mbstring php7.2-json \
  php7.2-mysql php7.2-pgsql php7.2-gd php7.2-bcmath php7.2-readline \
  php7.2-zip php7.2-imap php7.2-xml php7.2-json php7.2-intl php7.2-soap \
  php7.2-memcached php7.2-xdebug php7.2-redis

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
  && php composer-setup.php --install-dir=/usr/bin --filename=composer \
  && php -r "unlink('composer-setup.php');"

RUN npm i npm@latest -g \
  && yarn --global install \
  && yarn --global upgrade

RUN apt-get -y autoclean \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
