FROM ubuntu:bionic

ARG http_proxy
ARG https_proxy
RUN apt-get update \
 && apt-get install -yq --no-install-recommends nginx-extras gosu apache2-utils libnginx-mod-http-dav-ext \
 && rm -rf /var/lib/apt/lists/*

RUN ln -sf /dev/stderr /var/log/nginx/error.log
RUN chmod go+rwX -R /var /run
VOLUME /media
VOLUME /config

COPY entrypoint.sh /
COPY nginx.conf /etc/nginx/
COPY nginx-ssl.conf /etc/nginx/

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
