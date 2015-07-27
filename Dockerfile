FROM php:5.6-apache
MAINTAINER Madoma73

# confs eeodmus
ENV eedomus_apiuser=api\ user\
    eedomus_apisecret=very\ secret\ 
    eedomus_adressip=192.168.1.1

# conf DB
ENV DbHost=192.168.10.10\
    DbPort=3306\
    DbSchema=domodata\
    DbLogin=domodata\
    DbPassword=domodata

# environnement
ENV EnvPlatform=PROD\
	EnvUpdate=TRUE\
    EnvVirt=DOCKER \
    TERM=vt100

# install needed packages and cleanup in the same layer
RUN apt-get update && apt-get install -y \
      apt-utils \
      vim \
      net-tools \
      git \
      libmcrypt-dev\
      libxslt-dev\
      php5-mcrypt\
      wget\
      zlibc\
      zlib1g-dev\
    &&  docker-php-ext-install pdo_mysql \
    &&  docker-php-ext-install mcrypt \
    &&  docker-php-ext-install xsl \
    &&  docker-php-ext-install zip \
    &&  apt-get clean autoclean \
    &&  apt-get autoremove -y \
    &&  rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    &&  rm -rf /var/lib/apt/lists/*

# apache/php configuration
RUN a2enmod rewrite\
     && php5enmod mcrypt


#ADD sources /var/www/html/.
# Get sources from GitHub
RUN mkdir /DomodataGit \
    && cd /DomodataGit \
    && git clone "https://github.com/ppollet73/domotique_data.git" \
    && cd /DomodataGit/domotique_data/DomoData \
    && cp -R -f . /var/www/html/. \
    && chown -R www-data:www-data /var/www/html/xml

## configure PHP env
WORKDIR /var/www/html
RUN php composer.phar self-update
RUN php composer.phar install

#Configure Log
RUN mkdir /var/log/Domodata
RUN chown www-data:www-data /var/log/Domodata

EXPOSE 80