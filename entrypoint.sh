#!/bin/sh -eux

if [ -n "${WEBDAV_USERNAME:-}" ] && [ -n "${WEBDAV_PASSWORD:-}" ]; then
    htpasswd -cb /etc/nginx/webdavpasswd $WEBDAV_USERNAME $WEBDAV_PASSWORD
else
    echo "No htpasswd config done"
    sed -i 's%auth_basic "Restricted";% %g' /etc/nginx/nginx.conf
    sed -i 's%auth_basic_user_file webdavpasswd;% %g' /etc/nginx/nginx.conf
fi

if [ -n "${WEBDAV_READONLY:-}" ] ; then
        if [ "${WEBDAV_READONLY}" = "1" ] ; then
                echo "Running in readonly mode"
                sed -i 's%dav_methods%# dav_methodes%g' /etc/nginx/nginx.conf
        fi
fi

if [ -n "${UID:-}" ]; then
    chmod go+w /dev/stderr /dev/stdout
    gosu $UID mkdir -p /media/.tmp
    exec gosu $UID "$@"
else
    mkdir -p /media/.tmp
    exec "$@"
fi
