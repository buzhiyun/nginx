FROM nginx:1.16.1

ADD nginx.conf /etc/nginx/nginx.conf

# 后续要增加的server站点
# http项目的conf文件 映射到 /etc/nginx/conf.d 下
# stream项目的conf文件 映射到 /etc/nginx/stream.d 下
