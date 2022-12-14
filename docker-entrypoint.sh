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


if [ -z "${NGINX_ENTRYPOINT_QUIET_LOGS:-}" ]; then
    exec 3>&1
else
    exec 3>/dev/null
fi

if [ "$1" = "nginx" -o "$1" = "nginx-debug" ]; then
    if /usr/bin/find "/docker-entrypoint.d/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
        echo >&3 "$0: /docker-entrypoint.d/ is not empty, will attempt to perform configuration"

        echo >&3 "$0: Looking for shell scripts in /docker-entrypoint.d/"
        find "/docker-entrypoint.d/" -follow -type f -print | sort -V | while read -r f; do
            case "$f" in
                *.sh)
                    if [ -x "$f" ]; then
                        echo >&3 "$0: Launching $f";
                        "$f"
                    else
                        # warn on shell scripts without exec bit
                        echo >&3 "$0: Ignoring $f, not executable";
                    fi
                    ;;
                *) echo >&3 "$0: Ignoring $f";;
            esac
        done

        echo >&3 "$0: Configuration complete; ready for start up"
    else
        echo >&3 "$0: No files found in /docker-entrypoint.d/, skipping configuration"
    fi
fi

checkConf &

if [[ "$WORK_USER" != "nginx" ]]; then
  echo try add user ${WORK_USER}
  if [ -z $WORK_USERID ];then
    adduser -D ${WORK_USER}
    echo 'create user' ${WORK_USER}
  else
    adduser -D -u ${WORK_USERID} ${WORK_USER}
    echo 'create user' ${WORK_USER} ',user id:'  ${WORK_USERID}
  fi
fi

echo worker_processes ${WORK_PROCESSES} ", user" ${WORK_USER}
#exec "nginx -g 'daemon off;worker_processes ${WORK_PROCESSES};'"
nginx -g 'daemon off;worker_processes '${WORK_PROCESSES}';user '${WORK_USER}';'
#exec "$@"

