# 使用官方 PHP + Apache 环境
FROM php:7.4-apache

# 启用 Apache rewrite 模块（ThinkPHP 需要）
RUN a2enmod rewrite

# 将代码复制到容器
COPY . /var/www/html/

# 设置工作目录为 public
WORKDIR /var/www/html/public

# 暴露端口
EXPOSE 8080

# 启动 Apache
CMD ["apache2-foreground"]
