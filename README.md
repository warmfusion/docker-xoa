# README

This image contains a build of xo-server and xo-web from the stable line and an explict 5.2.0 build.


## Running


Quickstart by simply running the following;

```
docker run -d --name xoa -P 8443:443 warmfusion/xoa:redis
```

Then browsing to https://localhost:8443

## SSL

The container is secured using a self-signed ssl certificate generated when the container is built.

This ensures that any communication to the container is secure by default and this should not be circumvented.

Support for customised keys is not yet in place, however you may have some luck with mounting a directory
with config and appropriate pem keys using a volume mount as follows;


```
docker run -v config/:/etc/xo-server/ ....
```


# Docker tags

## :latest

This is a simple build which only runs xen-orchestra and assumes you are using a linked redis container named xoa-redis.

> WARNING: This container does _NOT_ work due to [bug 390 in xo-server](https://github.com/vatesfr/xo-server/issues/390)

## :redis

This container is an extension of the :latest container and runs redis-server alongside xen orchestra using supervisord.

It is based on the container built by [jpoa/docker-xo](https://github.com/jpoa/docker-xo)

> WARNING: This mode is not recommended as redis contains the configuration for your installation; any updates to this container will
> result in the configuration being wiped out.