FROM nginx:1.24.0-alpine

ADD nginx.conf /etc/nginx/nginx.conf
ADD ali-* /usr/local/sbin/
ADD docker-entrypoint.sh /
#RUN rm /docker-entrypoint.d/30-tune-worker-processes.sh
# 后续要增加的server站点
# http项目的conf文件 映射到 /etc/nginx/conf.d 下
# stream项目的conf文件 映射到 /etc/nginx/stream.d 下
ENV WORK_PROCESSES=4
ENV WORK_USER=nginx
# ENTRYPOINT []
CMD []
# CMD ["nginx","-g","daemon off;worker_processes $WORK_PROCESSES;"]
