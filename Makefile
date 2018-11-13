################################################################
#
#	GENERAL - Build on a Production Machine 
#
################################################################
bin = ./bin
source = ./source

all:
	#TODO do allthings inorder on a new machine

man:
	echo "make manpages and install them"

readme:
	echo "# cityboxio.backend" > README
	echo "" >> README
	banner citybox.io >> README
	echo "" >> README
	tree >> README

################################################################
#
#	DEVELOPMENT - Build on a Development Machine 
#
################################################################
github:
	#TODO indent(1) sourcefiles; 
	#TODO check compile success without error nor warnings;
	git add .;git commit -m "$m";git push
	#TODO for local sourcecode storage use /usr/src/bin/citybox; 

################################################################
#
#	TESTING - Build on a Testing Machine 
#
################################################################
test:
	#TODO testall: endpoints daemons usersA userB
	#TODO test: run daemon and store its pid
	#TODO test: kill daemon via its pid

clean:
	@echo "cleaning ./bin"
	rm -rf ./bin
	mkdir ./bin
	#TODO clean *.socks 
	#TODO clean DATA.test

################################################################
#
#	PRODUCTION - Build on a Production Machine 
#
################################################################
openbsd:
	#TODO a shellscript for the following:
	#TODO create user citybox on obsd
	#TODO configure /etc/doas.conf for user citybox to run things 
	#TODO update httpd configuration
	#TODO update rc.conf.local
	#TODO pkg_add jq for working with shellscripts and awk queries 

setup:
	@banner "citybox.io >"
	@echo "Welcome to Citybox.io Interactive Setup"
#
# cattle not pet an openbsd box
#

#
#	Each microservice is an endpoint, commands endpointd, and queries endpointd 
# 	somehow supply the names of the microservice(s) here and the rest gets done
#	Makefile to be used on different machines to operate specific microservice(s)
#
# execute endpoint with specific name
# execute commands_endpointd with specific name
# execute queries_endpointd with specific name
#TODO 	execute the dependent tasks for microservices 
#	like configure slowcgi and httpd,etc. in another tasks
#TODO 	a loop with versions and endpoint names to populate microservices:
#endpoints_array = opendatahub rd apidoc ping 
#for endpoint in ${endpoints_array}
#	do
#		#cc -static -g -W -Wall -o $(bin)/$(endpoint) $(source)/endpoint.c 
#		echo ${endpoint}	
#	done
microservices: clean
	doas sh ./config/endpoint.sh v1 opendatahub
	doas sh ./config/endpointd.sh commands opendatahub
	doas sh ./config/endpointd.sh queries opendatahub
	#TODO capture domain-language into shellscripts in ./domain and execute them; this task creates a domain.	
	#TODO (bad idea) a daemon to monitor the logs of commands and transform them into events with full data in ./DATA/opendatahub.json.db so a queries daemon can read them from there.
	#TODO touch ./DATA/opendatahub.json.eventstore db to append/read all this endpoint events; which if implemented as merkle tree can be used for blockchain.
	# /usr/local/pgsql/data
	#TODO 	The install command uses the cp, chown, chmod, and strip commands.
	# 	Makefile should create and use "citybox" user on obsd 
	# 	/etc/doas.conf `permit persist $USER cmd install`
	doas install ./domain/opendatahub-create_event-queries.sh /usr/local/bin/
	#doas sh /bin/cp ./domain/opendatahub-* /usr/local/bin/
	#/bin/cp ./domain/opendatahub-* /usr/local/bin/

opendatahub: 
	#TODO a script to touch domain/opendata* 	

security: 
	#TODO Public-key cryptography for microservices inter-communication
	#TODO https://github.com/cisco/cjose
api_doc: 
	#TODO generate JSON schema of the API endpoints from the sourcecode heir(bin, domain, etc.)
	#TODO store it somewhere that makes sense!
whitepaper: 
	#TODO laTex whitepaper pdf
#
# blockchain shall use same sockets as httpd to communicate with the daemons
# thus /var/www/run/opendatahub.commands.sock can be used by chain/chaind  
#
blockchain: 
	#TODO createblock, blockhash, generateblock, storeblock, isblockvalid,
	#	broadcastblock, listallblocks, list/addpeers.
	#	blocks-of-events... a blockchain of events related to citybox.

#
# Deal with all databases for production
#
databases:
	#TODO create the hier of ./DATA
	#TODO 	where to store a ./DATA in obsd hier i.e. maybe /usr/local/citybox/DATA
	#	or /var/citybox/DATA

#
#TODO maybe not needed anymore, cleanup and delete it after careful review
#
#daemons:
#	doas sh ./config/daemon.sh
#	#TODO syslog setup (1.touch syslogfile, 2.restart syslogd)

#
#TODO should be the final task for everything to be working fine.
#
deploy:
	#TODO make deploy SERVER=api.citybox.io
	#TODO doas rcctl slowcgi restart (execlude from setup.sh)
	#TODO doas rcctl httpd restart
	echo  	"NOTE: /etc/doas.conf must be appended by"	
	echo 	"premit presist USER cmd sh"
