# NGINX WebDAV container

Usage:

```bash
docker run --restart always --detach --name webdav --publish 7000:8080 \
           --env UID=$UID --volume $PWD:/media ionelmc/webdav
```

Optionally you can add two environment variables to require HTTP basic authentication:

* WEBDAV_USERNAME
* WEBDAV_PASSWORD
* WEBDAV_READONLY
* WEBDAV_CERTIFICATE
* WEBDAV_CERTIFICATE_KEY

Example:

```bash
docker run --restart always --detach --name webdav --publish 7000:8080 \
           --env WEBDAV_USERNAME=myuser --env WEBDAV_PASSWORD=mypassword \
           --env WEBDAV_READONLY=1 \
           --env WEBDAV_CERTIFICATE=ssl-cert-snakeoil.pem \
           --env WEBDAV_CERTIFICATE_KEY=ssl-cert-snakeoil.key \
           --volume /mnt/data/certs:/config \
           --env UID=$UID --volume $PWD:/media ionelmc/webdav
```
