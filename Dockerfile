FROM node:argon-wheezy

RUN npm i -g npm

#TODO: Mash these into a single command
RUN apt-get update
RUN apt-get install -y build-essential libpng-dev git python-minimal


# Prepare for configuration...
RUN mkdir /etc/xo-server
# lets enable SSL mode using self-signed certificates
RUN openssl genrsa -out /etc/xo-server/xoa_local.key 2048  && \
    openssl req -new -x509 -key /etc/xo-server/xoa_local.key -out /etc/xo-server/xoa_local.crt -days 3650 -subj /CN=xoa.local



RUN git clone -b stable http://github.com/vatesfr/xo-server /app/xo-server && \
    git clone -b stable http://github.com/vatesfr/xo-web /app/xo-web

RUN cd /app/xo-server  && npm install && npm run build
RUN cd /app/xo-web     && npm install && npm run build




COPY config.yaml /etc/xo-server/config.yaml

VOLUME /etc/xo-server

EXPOSE 80
EXPOSE 443
WORKDIR /app/xo-server
CMD ["npm", "start"]


