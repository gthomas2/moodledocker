#!/bin/bash
apt-get install -y \
    php7.2-ssh2 \
    libssh2-1-dev
spawn install -f ssh2-alpha
expect "libssh2 prefix? [autodetect] :"
send "\r"
echo "extension=ssh2.so" >> /etc/php/7.2/fpm/php.ini
echo "extension=ssh2.so" >> /etc/php/7.2/cli/php.ini