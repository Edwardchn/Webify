FROM php:7.4-apache

# 安装依赖
RUN apt-get update && apt-get install -y --no-install-recommends libonig-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring \
    && a2enmod rewrite

# 设置 Apache 目录权限（避免 403）
RUN chown -R www-data:www-data /var/www/html

# 拷贝网站文件
COPY . /var/www/html/

# 设置工作目录为 ThinkPHP 的 Public
WORKDIR /var/www/html/Public

# Apache 监听 8080（Koyeb 要求）
RUN sed -i 's/80/8080/' /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 8080

# 保持容器前台运行
CMD ["apache2-foreground"]
