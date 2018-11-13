#! /bin/sh

#
# update httpd configuration
#
cp ./config/httpd.conf /etc/
echo "httpd configuration updated"

#
# update rc.conf.local
#
cp ./config/rc.conf.local /etc/
echo "/etc/rc.conf.local updated"

source="./src"
bin="./bin"
#TODO API version

server_ip="192.168.1.202"
endpoints="opendatahub rd apidoc ping" # array of all the endpoints 
for endpoint in $endpoints;
do
	echo "##############################"
	echo "compiling $endpoint"
	cc -static -g -W -Wall -o $bin/$endpoint $source/endpoint.c

	echo "installing $endpoint to /var/www/v1"
	doas install -o www -g www -m 0500 $bin/$endpoint /var/www/v1
	#doas -u www install -o www -g www -m 0500 $source/$endpoint /var/www/v1
	url="http://$server_ip/v1/$endpoint"
	echo "accessable from $url"
	echo "##############################"
	#echo "changing endpoint socket permissions"
	#srwxrwxrwx   1 root  daemon    0 Oct 25 12:57 endpoint.sock
	#srw-rw----   1 www   www       0 Oct 25 12:57 slowcgi.sock
	#chmod 777 /var/www/run/endpoint.sock #TODO fine tune it for more restrictive
	#echo "##############################"
done


#doas install -o www -g www -m 0500 $source/endpoint_test /var/www/v1

# Suppose you pull a disk from a decommissioned OpenBSD machine and you need to retrieve some files from it. 
# You want to mount the disk read-only so that you don’t change any of the files on the dis
# To manually mount a partition with options not specified in /etc/fstab, use the -o flag.
# For example, if the disk shows up as /dev/sd0 and you want to mount partition a, run this command:
#
# mount -o ro /dev/sd0a /mnt # read-only
# mount -o rw /dev/sd0a /mnt # read-write

#
# commands and queries for each endpoint are stored in bin/
#

#
# accessable from http://192.168.1.202/opendatahub/helloworld
#
#doas install -o www -g www -m 0500 $source/helloworld /var/www/opendatahub 

doas rcctl disable slowcgi
doas rcctl enable slowcgi
doas rcctl stop slowcgi
doas rcctl start slowcgi
doas rcctl check slowcgi

doas rcctl disable httpd 
doas rcctl enable httpd 
doas rcctl stop httpd 
doas rcctl start httpd
doas rcctl check httpd 
#doas rcctl restart httpd

# chroot -u www /var/www perl # To test if a program runs in the www chrooted enviroment
# doas -u www ls run/ # to test if it can run as www
#
# chroot -u www /var/www/ v1/opendatahub


# ldd(1) to check a program we want to run in chroot 

# ln(1) to make softlinks only (hardlinks are bad security)

# Do not alter rc.conf(8) directly. Instead, use the rcctl(8) utility to maintain the /etc/rc.conf.local file. 
# This makes future upgrades easier as all the changes are in the one file that isn't touched during upgrade. 

#
# cat /var/www/logs/error.log to debug why scripts aren't working!
#

#
# always use `chroot -u www /var/www program` to check it it works now after it has been installed in chroot
# chroot -u www /var/www jq --version
#

# test endpoints
# curl -sD- -o/dev/null https://api.citybox.io/opendatahub 
# curl -sD- -o/dev/null https://api.citybox.io/apidocs
# curl -sD- -o/dev/null https://api.citybox.io/rd
#
