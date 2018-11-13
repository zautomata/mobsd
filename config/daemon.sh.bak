#! /bin/sh

#doas rcctl disable syslogd 
#doas rcctl enable syslogd 
#doas rcctl stop syslogd 
#doas rcctl start syslogd 
doas rcctl restart syslogd 
echo "##############################"
echo "compiling endpointd daemon"
#cc ./src/endpointd.c -o ./bin/endpointd
cc -D SOCK_PATH='"/var/www/run/opendatahub.commands.sock"' -o ./bin/endpointd -Wall ./src/endpointd.c
#cc -o $bin/endpointd $source/endpointd.c
echo "##############################"
echo "TODO installing endpointd daemon"
echo "running endpointd daemon"
cd bin
./endpointd
