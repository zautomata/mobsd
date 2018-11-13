/**
 **
 **	endpointd.c -- the daemon for endpoint.c;
 **
 **	make(1) is used to generate it into endpoint_name-commands-daemon 
 ** 	or endpoint_name-queries-daemon
 **
 **/

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <syslog.h>

#include <sys/stat.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>

int sock_config(void); /* configure the sock */
char* read_file(void); /* a dumb test to read file from disk */

//TODO style9 check and indent

//TODO #include "jsmn.h" /* use jsmn to handle jsons */

//TODO define gaurds for #define SOCK_PATH macro into a static global variable
#define SOCK_PATH 	"/var/www/run/" SOCK

int s, s2, len;				/* */
unsigned t;				/* */
struct sockaddr_un local, remote;	/* */

//TODO 	each function either read global variables or 
//	write global variables but never both
//TODO 	local variables are private static

/*
 * main()
 *
 */
	int
main(void)
{
	//TODO	add pledge

	printf("%s", getprogname());
	openlog(getprogname(), LOG_PID | LOG_NDELAY, LOG_PERROR);
	//openlog("opendatahub-commands-daemon", LOG_PID | LOG_NDELAY, LOG_PERROR);
	//openlog("rd", 0, LOG_INFO);
	//TODO	update syslog.conf to log to two seperate files based on
	//	commands.sock, queries.sock per endpoint
	//TODO 	customize openlog params
	//TODO 	close log

	//TODO int create_sockstream()
	/* Create a new UNIX Socket */
	if ((s = socket(AF_UNIX, SOCK_STREAM, 0)) == -1) {
		/* if ((s = socket(AF_UNIX, SOCK_DGRAM, 0)) == -1) { */
		perror("socket");
		exit(1);
	}

	local.sun_family = AF_UNIX;
	/* strcpy(local.sun_path, SOCK_PATH); */

	strlcpy(local.sun_path, SOCK_PATH, sizeof(SOCK_PATH));
	unlink(local.sun_path);

	len = strlen(local.sun_path) + sizeof(local.sun_family+1);
	if (bind(s, (struct sockaddr *)&local, len) == -1) {
		perror("bind");
		exit(1);
	}

	//TODO	make SOCK_PATH socket permisions and ownership here.
	// 	and not in the setup script
	sock_config();

	for(;;) {
		int done, n;
		
		/* sock_waiting() */
		//TODO adjust proper LOG_DEBUG for debugging things
		syslog(LOG_INFO, "%s", "Waiting for connection...");
		printf("Waiting for a connection...\n");

		/* sock_accepting */
		t = sizeof(remote);
		if ((s2 = accept(s, (struct sockaddr *)&remote, &t)) == -1) {
			perror("accept");
			exit(1);
		}
		printf("Connected.\n");

		//TODO Should be forking a process dedicated to handle this client only
		//TODO non-blocking mode (MSG_DONTWAIT flag)


		/* sock_receiving() */
		/* httpd default maxrequestbody is 1048576bytes (1M) */
		int buffer_size = 1048576;
		char buffer[buffer_size];
		done = 0;
		do {
			//printf("buffer: %s\n", buffer);
			n = recv(s2, buffer, buffer_size, 0);
			syslog(LOG_DEBUG, "s2: %i\n", s2);
			syslog(LOG_DEBUG, "buffer: %s\n", buffer);
			syslog(LOG_DEBUG, "n: %i\n", n);

			if (n <= 0) {
				if (n < 0) perror("recv");
				printf("CQRS: %s\n", buffer);
				//syslog(LOG_INFO, "CQRS: %s", buffer);
				syslog(LOG_DEBUG, "CQRS: %s", buffer);
				//TODO logging should be done to the daemon logs
				//syslog(LOG_DAEMON, "CQRS: %s", buffer);
				syslog(LOG_USER, "CQRS: %s", buffer);
				// zero back the str(received message) to hold next request
				memset(buffer,'\0',sizeof(buffer));
				done = 1;
			}

			if (!done) {


				//TODO if the request was a command then this daemon is a command daemon
				//-> return to client an acknolgment that the their message was resviced(json format)
				//TODO if the request was a query then this daemon is a query daemon
				//-> return to query result (json format)
				char* payload = "executing the recevied jsonified command/query with its params\
						 to domain/endpoint_name/command_or_query.sh and returning its \
						 json result to the webapplication - you; resulting in an event \
						 appended to the eventstore";


				printf("endpointd: syslog executing the bounded context construct from the CQRS buffer\n\n\n");
				/* executing the bounded context */
				//cqrs_dispatcher(buffer, buffer_size);
				//cqrs_dispatcher(int buffer[], int buffer_size)
				printf("buffer after cqrs_dispatcher: %s\n\n\n", buffer);
				cqrs_dispatcher();


				if (send(s2, payload, strlen(payload), 0) < 0) {
					perror("send");
					done = 1;
				}
			}
		} while (!done);
		/* end of sock_receiving() */

		close(s2);
	}
	
	return(EXIT_SUCCESS);

	}

	int
sock_config(void)
{
	if (chmod(SOCK_PATH, 0777) != 0)
		//TODO syslog
		perror("chmod() error");
	else {
		//TODO syslog
		printf("permission changed\n");
	}

	if (listen(s, 5) == -1) {
		perror("listen");
		exit(1);
	}
	return(EXIT_SUCCESS);

}
/*
// usage char* payload = read_file();
	char* 
read_file(void)
{				
	//TODO fix truncation after endoflines
	FILE *fp;
	int ch;
	//TODO decide on the max size of a response.
	char txt[9000]; 
	int len=0;
	fp=fopen("./../DATA/README.md", "r");

	do {
		ch=fgetc(fp);
		txt[len]=ch;
		len++;
	} while(ch!=EOF);
	fclose(fp);

	return txt;
}
*/

/* Executed a DSL construct in a Bounded Context */
/* Args: */
/* Return: */
// cqrs_dispatcher(void)
	int
cqrs_dispatcher(void)
{
	//for (int i=0; i<buffer_size; i++) 
	//{ 
	//	buffer[i] = i; 
	//} 	
	//TODO use pipes instead
	FILE *fp;
	char result[1035];
	char bcc[100]; /* bounded context DSL construct */
	strlcat(bcc, ENDPOINT_NAME, sizeof(bcc));
	strlcat(bcc, "-", sizeof(bcc));
	strlcat(bcc, "create_event", sizeof(bcc)); /* create_event is extracted from json args*/
	strlcat(bcc, "-", sizeof(bcc));
	strlcat(bcc, DAEMON_TYPE, sizeof(bcc));
	strlcat(bcc, ".sh", sizeof(bcc)); /*TODO remove the extension */
	strlcat(bcc, " argument1 argument2", sizeof(bcc));
	//strlcat(bcc, buffer, sizeof(bcc));
	//printf("buffer %s", buffer);

	/* open the command for reading */
	/*IMPORTANT 	scripts go to /usr/local/bin/ for user cityboxio without their extension */
	/* 		i.e. opendatahub-xyz-command.sh become opendatahub-xyz-command */
	/* 		and opendatahub-xyz-command.1 allows users to use apropos and man pages */
	/* the boundedcontext construct is extracted from the json */
	//fp=popen("opendatahub-create_event-command.sh blah blah", "r");
	fp=popen(bcc, "r");

	/* to debug location in production when decided*/
	/* fp=popen("pwd", "r");  */

	if(fp==NULL){
		printf("failed to run command\n");
		exit(1);
	}

	/* read the output a line at a time - output it */
	while(fgets(result, sizeof(result), fp) !=NULL){
		//syslog(LOG_INFO, "bounded context executed.... %s", result);
		printf("bounded context result: %s", result);
	}
	/* close */
	pclose(fp);
	return 0;
}
