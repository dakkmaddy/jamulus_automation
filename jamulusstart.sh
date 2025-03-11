#!/bin/bash
runjam=$(ps -ef | grep -v grep | grep -c jamulus-headless)
pubip=$(curl http://icanhazip.com)
if [ $runjam = "0" ]
then
	echo "[-] runjam is $runjam, launching jamulus"
	/usr/bin/jamulus-headless --nogui --server -z -u 6 --serverpublicip $pubip --directoryaddress rock.jamulus.io:22424 -l /var/log/jamulus.log --jsonrpcport 10113 --jsonrpcsecretfile /srv/Jamulus/rpcsecret.txt -w /srv/Jamulus/jamuluswelcome.txt --serverinfo "willowjamz2025;richmond;us"
else 
	echo "[-] runjam is $runjam, which means jamulus is running"
fi
exit
