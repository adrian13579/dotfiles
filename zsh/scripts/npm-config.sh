#!/bin/bash
# Script for setting custom registries for npm
if [ $# = 1 ] ; then  
	if [ $1 = "uci" ] ; then
		echo "Setting nexus.prod.uci.cu registry..."
		npm config set registry http://nexus.prod.uci.cu/repository/npm-proxy/
		echo "Done!"
	else
		echo "Unknown registry $1"
	fi
else 
	echo "Setting default regisry..."
	# npm config set registry https://registry.npmjs.org/
	npm config delete registry
	echo "Done!"
fi

