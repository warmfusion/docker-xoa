FROM node:8.12-stretch

RUN npm install --global yarn
RUN apt-get update && \
    apt-get install -y build-essential redis-server libpng-dev git python-minimal libvhdi-utils lvm2 && \
    apt-get autoremove -qq && apt-get clean && rm -rf /usr/share/doc /usr/share/man /var/log/* /tmp/*

# Prepare for configuration...
RUN mkdir /etc/xen-orchestra
# lets enable SSL mode using self-signed certificates
RUN openssl genrsa -out /etc/xen-orchestra/xoa_local.key 2048  && \
    openssl req -new -x509 -key /etc/xen-orchestra/xoa_local.key -out /etc/xen-orchestra/xoa_local.crt -days 3650 -subj /CN=xoa.local

RUN git clone -b master http://github.com/vatesfr/xen-orchestra /app/xen-orchestra

RUN cd /app/xen-orchestra && yarn  && yarn build
COPY config.yaml /app/xen-orchestra/packages/xo-server/.xo-server.yaml

RUN mkdir /var/log/redis && chown redis:redis /var/log/redis

EXPOSE 80
EXPOSE 443
WORKDIR /app/xen-orchestra/packages/xo-server/
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["service redis-server start && yarn start"]
