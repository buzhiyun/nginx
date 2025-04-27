#!/bin/sh
# vim:sw=4:ts=4:et

#set -e

ln -s /usr/share/nginx/html /etc/nginx/html

function checkConf() {
    md5check=`ls -lR /etc/nginx/ | md5sum`
    while(true)
    sleep 10
    md5checkNew=`ls -lR /etc/nginx/ | md5sum`
    do
        if [ "$md5check" != "$md5checkNew" ];then
            nginx -t
            if [ $? -eq 0 ]; then
                nginx -s reload
                md5check=`ls -lR /etc/nginx/ | md5sum`
            fi
        fi
    done  

}


entrypoint_log() {
    if [ -z "${NGINX_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

# 这一段在启动的时候不适用 CMD ["nginx"] 之类的参数，不会生效
# 所以暂时先注释了
# if [ "$1" = "nginx" -o "$1" = "nginx-debug" ]; then
#     if /usr/bin/find "/docker-entrypoint.d/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
#         entrypoint_log "$0: /docker-entrypoint.d/ is not empty, will attempt to perform configuration"
# 
#         entrypoint_log "$0: Looking for shell scripts in /docker-entrypoint.d/"
#         find "/docker-entrypoint.d/" -follow -type f -print | sort -V | while read -r f; do
#             case "$f" in
#                 *.sh)
#                     if [ -x "$f" ]; then
#                         entrypoint_log "$0: Launching $f";
#                         "$f"
#                     else
#                         # warn on shell scripts without exec bit
#                         entrypoint_log "$0: Ignoring $f, not executable";
#                     fi
#                     ;;
#                 *) entrypoint_log "$0: Ignoring $f";;
#             esac
#         done
# 
#         entrypoint_log "$0: Configuration complete; ready for start up"
#     else
#         entrypoint_log "$0: No files found in /docker-entrypoint.d/, skipping configuration"
#     fi
# fi

checkConf &


# cp /etc/nginx/nginx.conf /etc/nginx/.nginx.conf.temp

# 检查是否有 WORK_PROCESSES 环境变量，如果没有则默认为 4
if [ -n $WORK_PROCESSES ];then
  WORK_PROCESSES=${WORK_PROCESSES}
  echo "worker_processes ${WORK_PROCESSES};" | cat - /etc/nginx/nginx.conf.temp > /etc/nginx/.nginx.conf.temp
  # echo "worker_processes ${WORK_PROCESSES};" | cat - /etc/nginx/nginx.conf > /etc/nginx/nginx.conf
fi


# 检查是否有 WORK_USER 环境变量，如果没有则默认为 nginx
if [[ "$WORK_USER" != "nginx" ]]; then
  entrypoint_log try add user ${WORK_USER}
  # echo "user ${WORK_USER};" | cat - /etc/nginx/nginx.conf > /etc/nginx/nginx.conf

  # 检查是否有 WORK_USERID 环境变量，如果没有则默认为 1000
  if [ -z $WORK_USERID ];then
    adduser -D ${WORK_USER}
    entrypoint_log 'create user' ${WORK_USER}
  else
    adduser -D -u ${WORK_USERID} ${WORK_USER}
    entrypoint_log 'create user' ${WORK_USER} ',user id:'  ${WORK_USERID}
  fi
fi
echo "user ${WORK_USER};" | cat - /etc/nginx/.nginx.conf.temp > /etc/nginx/nginx.conf

entrypoint_log worker_processes ${WORK_PROCESSES} ", user" ${WORK_USER}
#exec "nginx -g 'daemon off;worker_processes ${WORK_PROCESSES};'"
# nginx -g 'daemon off;worker_processes '${WORK_PROCESSES}';user '${WORK_USER}';'
# nginx -g 'daemon off;'

exec "$@"

