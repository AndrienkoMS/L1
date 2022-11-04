#!/bin/bash

allfunction(){
	echo "Hosts in the current subnet:"
	nmap -sP 10.0.10.0/24
	return 0
}

openTCP(){
	echo -e "open TCP ports are:\n"
	sudo netstat -tln | grep LISTEN
	return 0
}

QTY=$#
if [[ $QTY -gt 1 ]]
then 
	echo -e "Only one argument is allowed\nAvailable arguments are:\n--aa|--target"
	exit 0
else if [[ $QTY -eq 0 ]] 
then
	echo -e "You should type argument: --aa|--target"
	exit 0
fi
fi

case $1 in
	--all)
		echo -e "--all command"
		allfunction
		;;
	--target)
		echo "--target command"
		openTCP
		;;
	*)
		echo -e "unknown command\nTry: --all|--target"
		;;
esac
