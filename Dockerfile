# 使用官方 PHP 7.4 + Apache 环境
FROM php:7.4-apache

# 启用 Apache rewrite 模块（ThinkPHP 必须）
RUN a2enmod rewrite

# 安装常用扩展（ThinkPHP 经常需要）
RUN docker-php-ext-install pdo pdo_mysql mbstring

# 复制网站文件到容器
COPY . /var/www/html/

# 设置工作目录到 public（ThinkPHP 的入口）
WORKDIR /var/www/html/Public

# 暴露端口
EXPOSE 8080

# 启动 Apache
CMD ["apache2-foreground"]
