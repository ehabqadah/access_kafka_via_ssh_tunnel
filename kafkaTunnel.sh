#!/bin/bash

zookeepers=""
bootstrap_servers=""
remote_machine=""
MULT_HOSTS_SEPARATOR=','
HOST_PORT_SEPARATOR=':'
hosts_list=""
host_port=""
allLocalForwarding="ssh "
if [ "$#" -ne 6 ]; then
   echo >&2 \ "USAGE: $0 [--remote-machine user@hostname] [--zookeeper host1:port1, ...] [---bootstrap host1:port1, ...]"
  exit 1
fi

while [ $# -gt 0 ]
do
    case "$1" in
        --zookeeper) zookeepers="$2"; shift;;
	--bootstrap-server) bootstrap_servers="$2"; shift;;
	--remote-machine) remote_machine="$2"; shift;;
	--*) echo >&2 \ "USAGE: $0 [--remote-machine user@hostname] [--zookeeper host1:port1, ...] [---bootstrap host1:port1, ...]"
	    exit 1;;
	*)  break;;	# terminate while loop
    esac
    shift
done

getListOfHosts(){

IFS=$MULT_HOSTS_SEPARATOR read -r -a hosts_list <<< "$1"

}

splitHostPort(){
IFS=$HOST_PORT_SEPARATOR read -r -a host_port <<< "$1"
}
# Assign loopback IP address
addLoopbackLink(){
	
	sudo ip add a dev lo $1
}

# Delete loopback IP address
removeLoopbackLink(){
	
	 sudo ip a d dev lo $1
}

addLoopbackOfHostsList(){	
	getListOfHosts $1
	for host_url in "${hosts_list[@]}"
	do
		splitHostPort $host_url
		addLoopbackLink ${host_port[0]}		    
	done
}

deleteLoopbackOfHostsList(){

	getListOfHosts $1
	for host_url in "${hosts_list[@]}"
	do
		splitHostPort $host_url
		removeLoopbackLink ${host_port[0]}
	    
	done
}

addHostToLocalForwarding(){

getListOfHosts $1
	for host_url in "${hosts_list[@]}"
	do
		allLocalForwarding+=" -L "$host_url":"$host_url" "
			    
	done
}

addLoopbackOfHostsList $zookeepers
addLoopbackOfHostsList $bootstrap_servers



addHostToLocalForwarding $zookeepers

addHostToLocalForwarding $bootstrap_servers

allLocalForwarding+=$remote_machine

$allLocalForwarding


echo "delete all created loopback interfaces"
deleteLoopbackOfHostsList $zookeepers
deleteLoopbackOfHostsList $bootstrap_servers
