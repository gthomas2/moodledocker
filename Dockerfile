FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    nginx \
    php7.2 \
    php7.2-fpm \
    php7.2-pgsql \
    php7.2-mysql \
    php7.2-xml \
    php7.2-mbstring \
    php7.2-curl \
    php7.2-zip \
    php7.2-gd \
    php7.2-intl \
    php7.2-xmlrpc \
    php7.2-soap \
    #Required for xdebug.
    php-xdebug \
    #Required for PHP PEAR.
    expect \
    php7.2-dev \
    php-pear \
    #Required for php unit init.
    locales \
    git \
    #For using supervisord.
    supervisor \
    #For using chromedriver (behat).
    wget \
    libnss3-dev \
    # For latest chrome.
    libappindicator1 \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatspi2.0-0 \
    libdrm2 \
    libgbm1 \
    libgtk2.0-0 \
    libx11-xcb1 \
    libxcb-dri3-0 \
    libxss1 \
    libxtst6 \
    xdg-utils \
    # For Mailhog.
    golang-go

# Install Mailhog
COPY scripts/installmailhog.sh /tmp/installmailhog.sh
RUN chmod +x /tmp/installmailhog.sh
RUN sh -c "/tmp/installmailhog.sh"

# Install PEAR
#COPY scripts/installpear.sh /tmp/installpear.sh
#RUN chmod +x /tmp/installpear.sh
#RUN sh -c "/tmp/installpear.sh"

# Install php xdebug
RUN sh -c "mkdir -p /run/php; touch /run/php/php7.2-fpm.sock"
RUN sh -c "mkdir -p /var/log/xdebug"
RUN sed -i 's/# en_AU.UTF-8 UTF-8/en_AU.UTF-8 UTF-8/' /etc/locale.gen && locale-gen

# Copy values in custom php.ini to end of default php.ini
COPY resources/php.ini /tmp/php.ini
RUN sh -c "cat /tmp/php.ini >> /etc/php/7.2/fpm/php.ini"

# Enable xdebug
RUN phpenmod xdebug
COPY resources/xdebug.ini /tmp/xdebug.ini
# Note - we are just adding to the end of the original xdebug.ini
RUN sh -c "cat /tmp/xdebug.ini >> /etc/php/7.2/mods-available/xdebug.ini"

# Copy hosts from sites-enabled to /etc/hosts
COPY scripts/processhosts.php /tmp/processhosts.php
RUN chmod +x /tmp/processhosts.php

# Install chrome driver (for behat).
COPY scripts/installchromedriver.sh /tmp/installchromedriver.sh
COPY scripts/installchrome.sh /tmp/installchrome.sh
RUN chmod +x /tmp/installchromedriver.sh
RUN chmod +x /tmp/installchrome.sh
RUN sh -c "/tmp/installchromedriver.sh"
RUN sh -c "/tmp/installchrome.sh"

#Create moodle data dir.
RUN mkdir -p /var/www-data/moodle
RUN chmod 700 /var/www-data/moodle
RUN chown www-data:www-data /var/www-data/moodle

#Create dir to log php-fpm.
RUN mkdir -p /var/log/php-fpm

COPY resources/config.php /tmp/config.php
COPY scripts/startup.php /tmp/startup.php
RUN chmod +x /tmp/startup.php

EXPOSE 80 443 8025

STOPSIGNAL SIGTERM

COPY supervisord.conf /etc/supervisord.conf

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
