FROM alpine:3.14
# Alpine v3.14 will install php v8.0

RUN set -x \

    # create non-root user
    && adduser -D -u 1000 -S www-data -G www-data \

    # install required software packages
    && apk add --no-cache alpine-sdk nginx s6

COPY --chmod=755 ./dockerfiles/entrypoint.sh /
COPY --chmod=755 ./dockerfiles/setup.sh /
COPY --chmod=644 ./dockerfiles/nginx/default.conf /etc/nginx/http.d/
COPY --chmod=755 --chown=www-data:www-data ./dockerfiles/s6-scan/. /run/openrc/s6-scan/
COPY --chmod=u=rwX,go=rX --chown=www-data:www-data . /var/www/html/

# set configuration and optimize for production
RUN /setup.sh

# run with non-root user to ensure least privilege
USER www-data
WORKDIR /var/www/html
ENTRYPOINT ["/entrypoint.sh"]
CMD ["sh"]
