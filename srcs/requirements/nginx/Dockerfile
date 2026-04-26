FROM debian:bookworm

ARG DOMAIN
#what does it mean DOMAIN ??

RUN apt-get update && apt-get install -y nginx openssl

#what is openssl and what is nginx ??

RUN mkdir -p /etc/nginx/ssl \
&& openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/nginx/ssl/nginx.key \
-out /etc/nginx/ssl/nginx.crt \
-subj "/CN=${DOMAIN}"

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]