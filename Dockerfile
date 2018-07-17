FROM ubuntu:latest

LABEL maintainer="Raza Mehdi<srmk@outlook.com>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get -y install apt-utils \ 
  && apt-get -y install curl zip unzip git openssl sqlite3 build-essential software-properties-common \
  && apt-get -y upgrade
  
RUN apt-get -y install supervisor gnupg tzdata \
  && echo "UTC" >> /etc/timezone \
  && dpkg-reconfigure -f noninteractive tzdata

RUN add-apt-repository ppa:nginx/stable \
  && add-apt-repository ppa:ondrej/php \
  && apt-get update

RUN apt-get -y install nginx php7.2-fpm php7.2-cli php7.2-curl php7.2-mcrypt \
  php7.2-mbstring php7.2-zip php7.2-json php7.2-mysql php7.2-pgsql php7.2-gd \
  php7.2-bcmath php7.2-imap php7.2-xml php7.2-json php7.2-intl php7.2-soap \
  php7.2-readline php7.2-memcached php-xdebug

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
  && php composer-setup.php --install-dir=/usr/bin --filename=composer \
  && php -r "unlink('composer-setup.php');"  

RUN apt-get -y autoclean \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && echo "daemon off;" >> /etc/nginx/nginx.conf

EXPOSE 80