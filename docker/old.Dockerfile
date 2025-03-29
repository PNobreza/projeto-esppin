FROM ubuntu/apache2:2.4-20.04_beta

ENV DEBIAN_FRONTEND=noninteractive
ENV TIMEZONE='America/Sao_Paulo'

RUN apt-get update

# Set Timezone
RUN ln -fs /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && apt-get install -y --no-install-recommends tzdata \
    && dpkg-reconfigure --frontend noninteractive tzdata
## -------- Config LOCALE ----------------
## and Install facilitators
ENV LANG=pt_BR.UTF-8
ENV LC_ALL=pt_BR.UTF-8
RUN apt-get -y install --no-install-recommends \
                locales wget apt-transport-https \
                locate wget apt-utils curl \
                apt-transport-https lsb-release \
                ca-certificates software-properties-common \
                zip unzip vim nano rpl \
                && echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen \
                && locale-gen pt_BR.UTF-8 \
                && dpkg-reconfigure --frontend=noninteractive locales

## -------- Configure REPO do PHP -----------
## para Debian
## RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
## RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
## para Ubuntu
## RUN apt-get install python-software-properties
RUN add-apt-repository ppa:ondrej/php -y
RUN apt-get update

RUN apt-get -y install apache2 \
        libapache2-mod-evasive \
        libapache2-mod-php8.2 \
        php8.2 \
        php8.2-cli \
        php8.2-common \
        php8.2-opcache \
        php8.2-curl \
        php8.2-dom \
        php8.2-xml \
        php8.2-zip \
        php-odbc \
        php8.2-soap \
        php8.2-intl \
        php8.2-bz2 \
        php8.2-xsl \
        php8.2-mbstring \
        php8.2-gd \
        php8.2-pdo \
        php8.2-pdo-pgsql \
        php8.2-pgsql \
        git-core

##        php8.2-xdebug \

## -------- Config Apache ----------------
## Enable .htaccess reading
RUN rpl "AllowOverride None" "AllowOverride All" /etc/apache2/apache2.conf
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
COPY ./docker/phpinfo.php /var/www/html/.
## Habilitação do APACHE
RUN a2dismod mpm_event \
    && a2dismod mpm_worker \
    && a2enmod mpm_prefork \
    && a2enmod rewrite \
    && a2enmod php8.2 

# ================ Configurando o ESPIN ================
COPY ./docker/php.ini /etc/php/8.2/apache2/php.ini
##COPY ./etc-apache2-sites-available-espin.conf /etc/apache2/sites-available/espin.conf
COPY . /var/www/html
COPY ./.htaccess /var/www/html/.htaccess
WORKDIR /var/www/html
RUN rm -rf /var/www/html/docker
RUN rm -f /var/www/html/index.html
RUN chown -R www-data:www-data /var/www/html
RUN chmod 777 -R /var/lib/php/sessions
##RUN a2ensite espin

## ------------- Finishing ------------------
# Limpe o cache do apt para reduzir o tamanho da imagem
# Creating index of files
RUN apt-get upgrade -y && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
