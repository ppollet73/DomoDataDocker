# in case of use with ARM processor 
# un comment this line and comment line 4 
# FROM madoma73/arm-php5.6
FROM php:5.6-apache


MAINTAINER Madoma73

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

# confs eedomus
ENV eedomus_apiuser=api\ user\
    eedomus_apisecret=very\ secret\ 
    eedomus_adressip=192.168.1.1

# conf DB
ENV DbHost=192.168.10.111\
    DbPort=3306\
    DbSchema=domodata\
    DbLogin=domodata\
    DbPassword=domodata
    
# environnement
ENV EnvPlatform=PROD\
    EnvUpdate=TRUE\
    EnvVirt=DOCKER \
    DelayBetweenApiCalls=1\
    TERM=vt100

#ADD sources /var/www/html/.
# Get sources from GitHub
RUN mkdir /DomodataGit \
    && cd /DomodataGit \
    && git clone "https://github.com/ppollet73/domotique_data.git" \
    && cd /DomodataGit/domotique_data/DomoData \
    && cp -R -f . /var/www/html/. \
    && mkdir /var/www/html/xml \
    && chown -R www-data:www-data /var/www/html/xml

## configure PHP env
WORKDIR /var/www/html
RUN wget http://getcomposer.org/composer.phar
RUN php composer.phar self-update
RUN php composer.phar install

#Configure Log
RUN mkdir /var/log/Domodata
RUN chown www-data:www-data /var/log/Domodata

#Replace apache startup script to update Domodata
COPY ./apache2-foreground /usr/local/bin/
COPY ./servername.conf /etc/apache2/conf-available/.
RUN a2enconf servername

RUN chmod +x /usr/local/bin/apache2-foreground

EXPOSE 80