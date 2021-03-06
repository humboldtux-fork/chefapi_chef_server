#!/bin/sh


### BEGIN INIT INFO
# Provides:             chefapi-node-auth
# Required-Start:       $local_fs $remote_fs
# Required-Stop:        $local_fs $remote_fs
# Should-Start:
# Should-Stop:
# Default-Start:        S
# Default-Stop:
# Short-Description:    Chefapi node auth rest service
### END INIT INFO

PATH="/sbin:/bin/:usr/sbin:/usr/bin:/usr/local/nodes/bin"
NAME="chefapi-node-auth"
DESC="Chefapi node auth rest service"

# chef client settings
. /usr/local/nodes/bin/settings.sh
running=$(ps -ef|grep main|grep "restport ${CHEFAPIAUTHPORT}"|grep -v grep|awk '{print $2}')

start()
{
	cd /root/go/src/github.com/MarkGibbons/chefapi_node_auth
	go run main.go -restcert ${CHEFAPIAUTHCERT} -restkey ${CHEFAPIAUTHKEY} -restport ${CHEFAPIAUTHPORT} </dev/null 1>/tmp/chefapi_node_auth.log 2>&1 &
}
stop()
{
	echo "${running}" | xargs -L1 kill -9 
}

case "${1}" in
	restart)
		stop
		start
		;;
	start)
		# start the node auth rest service
		if [ -z "${running}" ]; then
			start
			exit $?
		fi
		;;
	stop)
		if [ -n "${running}" ]; then
			stop
		fi
		;;
	status)
		if [ -n "${running}" ]; then
			echo "chefapi node auth is running"
		else
			echo "chefapi node auth is not running"
			exit 1
		fi
		;;
esac
exit 0
