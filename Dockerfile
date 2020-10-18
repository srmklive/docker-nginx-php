FROM srmklive/docker-ubuntu:bionic

LABEL maintainer="Raza Mehdi<srmk@outlook.com>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get -y upgrade
  
RUN wget https://nginx.org/keys/nginx_signing.key \
  && apt-key add nginx_signing.key \
  && echo "deb https://nginx.org/packages/mainline/ubuntu/ bionic nginx" | tee /etc/apt/sources.list.d/nginx.list \
  && echo "deb-src https://nginx.org/packages/mainline/ubuntu/ bionic nginx" | tee /etc/apt/sources.list.d/nginx.src.list \
  && add-apt-repository ppa:ondrej/php \
  && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update

RUN apt-get -y install nginx nodejs yarn libpcre3 libssl1.1 openssl php7.2-fpm php7.2-cli php7.2-curl php7.2-mbstring \
  php7.2-json php7.2-mysql php7.2-pgsql php7.2-gd php7.2-bcmath php7.2-readline \
  php7.2-zip php7.2-imap php7.2-xml php7.2-json php7.2-intl php7.2-soap \
  php7.2-memcached php-xdebug php-redis

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php -r "if (hash_file('sha384', 'composer-setup.php') === 'c31c1e292ad7be5f49291169c0ac8f683499edddcfd4e42232982d0fd193004208a58ff6f353fde0012d35fdd72bc394') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
  && php composer-setup.php --install-dir=/usr/bin --filename=composer \
  && php -r "unlink('composer-setup.php');"  

RUN npm i npm@latest -g \
  && yarn --global install \
  && yarn --global upgrade

RUN apt-get -y autoclean \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
