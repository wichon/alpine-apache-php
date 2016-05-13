FROM alpine:3.3
MAINTAINER Luis Alonzo <wichon@gmail.com>
LABEL Description="A Simple apache/php image using alpine Linux for Web Apps"

# Setup apache and php
RUN apk --update add apache2 php-apache2 curl \
    php-json php-phar php-openssl php-mysql php-curl php-mcrypt php-pdo_mysql php-ctype \    
    && rm -f /var/cache/apk/* \
    && mkdir /run/apache2 \
    && mkdir -p /opt/utils \
    && sed -i 's#AllowOverride none#AllowOverride All#' /etc/apache2/httpd.conf
    
EXPOSE 80

ADD start.sh /opt/utils/

RUN chmod +x /opt/utils/start.sh

ENTRYPOINT ["/opt/utils/start.sh"]
