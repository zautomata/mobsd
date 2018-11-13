#! /bin/sh
#
#	Script to configure an endpoint daemon
#

source="./src"
bin="./bin"

daemon_type=$1 
endpoint_name=$2 
daemon_name="$endpoint_name-$daemon_type-daemon"
sock="$endpoint_name.$daemon_type.sock"

if [ "$daemon_type" == "commands" ]; then
echo "Creating socks for $daemon_name commands at $sock"
cc -D SOCK='"'$sock'"' -D ENDPOINT_NAME='"'$endpoint_name'"' -D DAEMON_TYPE='"'$daemon_type'"' -o ./bin/$daemon_name -Wall ./src/endpointd.c

elif [ "$daemon_type" == "queries" ]; then
echo "Creating socks for $daemon_name queries at $sock"
#cc -D SOCK='"'$sock'"' -o ./bin/$daemon_name -Wall ./src/endpointd.c
cc -D SOCK='"'$sock'"' -D ENDPOINT_NAME='"'$endpoint_name'"' -D DAEMON_TYPE='"'$daemon_type'"' -o ./bin/$daemon_name -Wall ./src/endpointd.c

else
echo "exit script as daemon_type is not recognized"
fi

echo "TODO touch the location of  $daemon_name log"
echo "TODO ammend /etc/syslog.conf to recognize $daemon_name and the location where to log it"
echo "restarting syslogd"
doas rcctl restart syslogd 

#echo "TODO installing and running endpointd daemon via rcctl to the openbsd system"
