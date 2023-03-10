FROM php:8.1-fpm-alpine
ARG uid=1000
ARG user=manda

RUN docker-php-ext-install pdo pdo_mysql

RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer -O - -q | php -- --quiet \
  && mv composer.phar /usr/local/bin/composer

RUN apk add --update-cache git curl zip unzip \
  && rm -rf /var/cache/apk/*

RUN adduser -u $uid -h /home/$user -D $user $user
RUN mkdir -p /home/$user/.composer && chown -R $user:$user /home/$user

RUN mkdir -p /srv/web/storage/framework/cache /srv/web/storage/framework/sessions /srv/web/storage/framework/views /srv/web/bootstrap/cache && \
    chown -R www-data:www-data /srv/web/storage /srv/web/bootstrap/cache  

RUN chmod 777 -R /srv/web/
RUN chmod 777 -R /srv/web/storage/framework/cache
RUN chmod 777 -R /srv/web/storage/framework/sessions
RUN chmod 777 -R /srv/web/storage/framework/views
RUN chmod 777 -R /srv/web/bootstrap/cache
RUN chmod 777 -R /srv/web/storage
# RUN chmod 777 -R /srv/web/public/images/
# RUN chown -R www-data:www-data /srv/web/public/images/

RUN chown -R $user:www-data /srv/web
RUN find /srv/web -type f -exec chmod 664 {} \;
# RUN chgrp -R www-data storage bootstrap/cache
# RUN chmod -R ug+rwx storage bootstrap/cache

COPY --chown=www:www . /srv/web

USER $user