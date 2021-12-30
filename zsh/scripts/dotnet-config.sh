#!/bin/bash
if [ $# = 1 ] ; then  
	if [ $1 = "uci" ] ; then
		echo "Setting nexus.prod.uci.cu source..."
		dotnet nuget add source http://nexus.prod.uci.cu/repository/nuget.org-proxy -n nuget.org-proxy 
	    dotnet nuget enable source nuget.org-proxy 
		echo "Done!"
	else
		echo "Unknown source $1"
	fi
else 
	echo "Setting default source..."
	dotnet nuget enable source nuget.org
	echo "Done!"
fi


