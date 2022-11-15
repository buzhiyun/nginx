FROM nginx:1.22.1-alpine

ADD nginx.conf /etc/nginx/nginx.conf
ADD ali-* /usr/local/sbin/
ADD docker-entrypoint.sh /
# 后续要增加的server站点
# http项目的conf文件 映射到 /etc/nginx/conf.d 下
# stream项目的conf文件 映射到 /etc/nginx/stream.d 下
