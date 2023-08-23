#!/bin/sh
# vim:sw=4:ts=4:et

#set -e

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

if [[ "$WORK_USER" != "nginx" ]]; then
  entrypoint_log try add user ${WORK_USER}
  if [ -z $WORK_USERID ];then
    adduser -D ${WORK_USER}
    entrypoint_log 'create user' ${WORK_USER}
  else
    adduser -D -u ${WORK_USERID} ${WORK_USER}
    entrypoint_log 'create user' ${WORK_USER} ',user id:'  ${WORK_USERID}
  fi
fi

entrypoint_log worker_processes ${WORK_PROCESSES} ", user" ${WORK_USER}
#exec "nginx -g 'daemon off;worker_processes ${WORK_PROCESSES};'"
nginx -g 'daemon off;worker_processes '${WORK_PROCESSES}';user '${WORK_USER}';'

#exec "$@"

