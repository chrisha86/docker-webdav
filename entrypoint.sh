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

if [ -n "${WEBDAV_CERTIFICATE:-}" ] && [ -n "${WEBDAV_CERTIFICATE_KEY:-}" ]; then
	if [ -e "/config/${WEBDAV_CERTIFICATE}" ] && [ -e "/config/${WEBDAV_CERTIFICATE_KEY}" ]; then
		echo "Running in SSL mode"
		sed -i 's%# include nginx-ssl.conf;%include nginx-ssl.conf;%g' /etc/nginx/nginx.conf
		sed -i 's%listen 8080 default_server;%listen 8080 ssl;%g' /etc/nginx/nginx.conf
		test -e /etc/nginx/cert.crt && rm /etc/nginx/cert.crt
		test -e /etc/nginx/cert.key && rm /etc/nginx/cert.key
		ln -s "/config/${WEBDAV_CERTIFICATE}" /etc/nginx/cert.crt
		ln -s "/config/${WEBDAV_CERTIFICATE_KEY}" /etc/nginx/cert.key
	else
		echo "Certificates not found"
		exit 1
	fi
else
	test -e /etc/nginx/cert.crt && rm /etc/nginx/cert.crt
	test -e /etc/nginx/cert.key && rm /etc/nginx/cert.key
	sed -i 's%include nginx-ssl.conf;%# include nginx-ssl.conf;%g' /etc/nginx/nginx.conf
	sed -i 's%listen 8080 ssl;%listen 8080 default_server;%g' /etc/nginx/nginx.conf
fi

if [ -n "${UID:-}" ]; then
    chmod go+w /dev/stderr /dev/stdout
    gosu $UID mkdir -p /media/.tmp
    exec gosu $UID "$@"
else
    mkdir -p /media/.tmp
    exec "$@"
fi
