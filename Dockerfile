FROM php:7.4-apache

# 先装 mbstring 依赖 oniguruma，再装 PHP 扩展
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends libonig-dev; \
    docker-php-ext-install pdo pdo_mysql mbstring; \
    rm -rf /var/lib/apt/lists/*

# 如果要用 ThinkPHP 的伪静态，别忘了启用 rewrite
RUN a2enmod rewrite

# 复制代码
COPY . /var/www/html/

# （推荐）把网站根目录指向 Public，并放行 .htaccess
RUN sed -i 's#DocumentRoot /var/www/html#DocumentRoot /var/www/html/Public#g' /etc/apache2/sites-available/000-default.conf \
 && printf '\n<Directory /var/www/html/Public>\n    AllowOverride All\n    Require all granted\n</Directory>\n' >> /etc/apache2/apache2.conf

EXPOSE 8080
CMD ["apache2-foreground"]
