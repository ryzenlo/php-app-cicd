ARG APP_BASE_IMG_NAME
ARG APP_BASE_IMG_VER
FROM ${APP_BASE_IMG_NAME}:${APP_BASE_IMG_VER}

WORKDIR /var/www/php/

ARG SOURCE_CODE_PATH

COPY ${SOURCE_CODE_PATH} .

RUN chmod -R 777 storage bootstrap/cache

RUN composer install --no-interaction --no-dev --prefer-dist

EXPOSE 80 443 9000

CMD [ "sh", "/etc/entrypoint.sh" ]