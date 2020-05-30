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

RUN apt-get -y install nginx nodejs yarn libpcre3 libssl1.1 openssl php7.3-fpm php7.3-cli php7.3-curl php7.3-mbstring \
  php7.3-json php7.3-mysql php7.3-pgsql php7.3-gd php7.3-bcmath php7.3-readline \
  php7.3-zip php7.3-imap php7.3-xml php7.3-json php7.3-intl php7.3-soap \
  php7.3-memcached php-xdebug php-redis

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
  && php composer-setup.php --install-dir=/usr/bin --filename=composer \
  && php -r "unlink('composer-setup.php');"

RUN npm i npm@latest -g \
  && yarn --global install \
  && yarn --global upgrade

RUN apt-get -y autoclean \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
