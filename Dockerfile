# PHP 7.4 + Apache
FROM php:7.4-apache

# 更严格：任何一步失败就退出
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# 系统依赖 + PHP 扩展（ThinkPHP 常用：pdo_mysql、mbstring、gd、zip）
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libpng-dev libjpeg-dev libonig-dev libzip-dev zip unzip curl; \
    docker-php-ext-configure gd --with-jpeg; \
    docker-php-ext-install -j"$(nproc)" pdo_mysql mbstring gd zip; \
    a2enmod rewrite; \
    rm -rf /var/lib/apt/lists/*

# 复制代码
WORKDIR /var/www/html
COPY . /var/www/html

# 把站点根改到 Public，并允许 .htaccess 生效
RUN sed -i 's#DocumentRoot /var/www/html#DocumentRoot /var/www/html/Public#g' /etc/apache2/sites-available/000-default.conf && \
    printf '\n<Directory /var/www/html/Public>\n    AllowOverride All\n    Require all granted\n</Directory>\n' >> /etc/apache2/apache2.conf

# 可选：如果项目有 composer.json，就安装依赖并优化自动加载
RUN if [ -f composer.json ]; then \
      curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
      composer install --no-dev --prefer-dist --no-progress --no-interaction && \
      composer dump-autoload -o; \
    fi

# 公开端口（与你在 Koyeb 里填的 8080 一致）
EXPOSE 8080
CMD ["apache2-foreground"]
