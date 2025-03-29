FROM ubuntu/apache2:2.4-20.04_beta

ENV DEBIAN_FRONTEND=noninteractive \
    TIMEZONE='America/Sao_Paulo' \
    LANG=pt_BR.UTF-8 \
    LC_ALL=pt_BR.UTF-8

# Atualiza pacotes e instala dependências essenciais em um único RUN para reduzir camadas
# Observar instalação do CRON
RUN apt-get update && apt-get install -y --no-install-recommends \
    tzdata locales wget curl lsb-release cron\
    ca-certificates software-properties-common \
    zip unzip git-core \
    && echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen pt_BR.UTF-8 \
    && ln -fs /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive locales tzdata

# Adiciona repositório do PHP e atualiza lista de pacotes
RUN add-apt-repository ppa:ondrej/php -y && apt-get update

# Instala Apache e PHP com extensões necessárias
RUN apt-get install -y --no-install-recommends \
    libapache2-mod-php8.2 \
    php8.2 php8.2-cli php8.2-common \
    php8.2-opcache php8.2-curl php8.2-dom \
    php8.2-xml php8.2-zip php-odbc \
    php8.2-soap php8.2-intl php8.2-bz2 \
    php8.2-xsl php8.2-mbstring php8.2-gd \
    php8.2-pdo php8.2-pdo-pgsql php8.2-pgsql \
    libapache2-mod-evasive git-core \
    locate wget apt-transport-https apt-utils curl \
    apt-transport-https lsb-release \
    ca-certificates software-properties-common \
    zip unzip vim nano rpl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Configuração do Apache
RUN rpl "AllowOverride None" "AllowOverride All" /etc/apache2/apache2.conf \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf \
    && a2dismod mpm_event mpm_worker \
    && a2enmod mpm_prefork rewrite php8.2

# ================ Configurando o ESPIN ================
# Copia arquivos necessários
COPY ./docker/entrypoint.sh /entrypoint.sh
COPY ./docker/crontab-root /etc/cron.d/crontab-root
COPY ./docker/phpinfo.php /var/www/html/
COPY ./docker/php.ini /etc/php/8.2/apache2/php.ini
COPY ./espin/ /var/www/html
COPY ./espin/.htaccess /var/www/html/.htaccess

# Ajusta permissões
# O TOUCH - Garante que o cron será executado no startup do container
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 777 /var/lib/php/sessions \
    && chmod 0644 /etc/cron.d/crontab-root \
    && chmod +x /entrypoint.sh \
    && crontab /etc/cron.d/crontab-root \
    && rm -f /var/www/html/index.html \
    && touch /var/log/cron.log

# Expõe a porta 80
EXPOSE 80

# Comando de inicialização
##CMD ["apachectl", "-D", "FOREGROUND"]
CMD ["/entrypoint.sh"]
