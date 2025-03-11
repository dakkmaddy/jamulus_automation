#!/bin/bash
#
# This is the api output from ipinfo.io
# curl https://ipinfo.io/103.125.146.41/json?token=469fad14e7deb1
#{
#  "ip": "103.125.146.41",
#  "city": "Shimoigusa",
#  "region": "Tokyo",
#  "country": "JP",
#  "loc": "35.7537,139.6035",
#  "org": "AS206092 Internet Utilities Europe and Asia Limited",
#  "postal": "177-0031",
#  "timezone": "Asia/Tokyo"
#
# Define variables
rightnow=$(date +%s)
outfile=/srv/Splunk/Jamulus/jamulus_connections.log
locationfile=/srv/Splunk/Jamulus/jamulus_locations.log
key="inputyourkeyhere"
#
# Header row
#echo "time,ipaddress,ASN,org,city,country,timezone" > $outfile
#
# First, verify the SSH tunnel is set up.
#
tunnelup=$(netstat -tunlp | grep -c "59999")
# If the tunnel is set, then we can use netcat to grab the original info
#
if [ $tunnelup != "0" ];
then
        echo "[-] Tunnel is up"
        cat /home/svcMaestro/Jamulus/apicommands.txt | nc -w 3 127.0.0.1 59999 | tr '{' '\n' | grep address | awk -F':' '{print $2 $5 $6 $10}' | sed 's/\"/ /g' | sed 's/  / /g' | awk -F',' '{print $1 $2 $3}' | sed 's/^.//'| tee tunneltmp.txt
        cat tunneltmp.txt | awk -F' ' '{print $1}' > /tmp/tunnelips.txt
        username=$(cat tunneltmp.txt | awk '{ print $(NF-0) }' > jamusers.tmp)
        echo "[-] Will be checking these IPs"
        cat /tmp/tunnelips.txt
else
        echo "[-] Tunnel is down"
        echo "$rightnow,Gtunneldown,Gtunneldown,Gtunneldown,Gtunneldown,Gtunneldown,Gtunneldown" | tee -a $outfile
        exit 1
fi
#
echo "[-] Parsing /tmp/tunnelips with IPInfo API key - outputs to $outfile"
echo
#echo "time,ipaddress,ASN,org,city,country,timezone" > $outfile
for loop in $(cat /tmp/tunnelips.txt)
do
        username=$(head -n1 jamusers.tmp)
        echo -e "$(sed '1d' jamusers.tmp)\n" > jamusers.tmp
        echo "[-] Checking IP Address $loop"
        curl -s "https://ipinfo.io/$loop/json?token=$key" > /tmp/ipinfo.parse
        sed -i 's/\"//g' /tmp/ipinfo.parse
        echo "[-] Getting user locations!"
        # Getting user locaton specifically here to get the location when the comma is beneficial to output
        # Following this info grab
        userlat=$(cat /tmp/ipinfo.parse | grep loc | awk -F':' '{print $2}' | cut -d',' -f1)
        userlong=$(cat /tmp/ipinfo.parse | grep loc | awk -F':' '{print $2}' | cut -d',' -f2)
        echo "[-] Coordinates of connected user are .... "
        echo "$rightnow,$username,$userlat,$userlong" | tee -a $locationfile
        # Now we can remove the uncessary commas from the tmp file curled from ipinfo.io
        sed -i 's/\,//g' /tmp/ipinfo.parse
        timezone=$(cat /tmp/ipinfo.parse | grep timezone | awk -F':' '{print $2}')
        country=$(cat /tmp/ipinfo.parse | grep country | awk -F':' '{print $2}')
        asn=$(cat /tmp/ipinfo.parse | grep org | awk -F':' '{print $2}' | cut -d' ' -f2)
        org=$(cat /tmp/ipinfo.parse | grep org | cut -d' ' -f3-)
        city=$(cat /tmp/ipinfo.parse | grep city | awk -F':' '{print $2}' | cut -d' ' -f2)
        echo "$rightnow,$loop,$asn,$org,$city,$country,$timezone" | tee -a $outfile
done
#cat /tmp/ipinfo.parse
rm -rf /tmp/ipinfo.parse
rm -rf /tmp/tunnelips.txt
rm -rf jamusers.tmp
# First, verify the SSH tunnel is set up.
#
tunnel2=$(netstat -tunlp | grep -c "60000")
# If the tunnel is set, then we can use netcat to grab the original info
#
if [ $tunnel2 != "0" ];
then
        echo "[-] Tunnel is up"
        cat /home/svcMaestro/Jamulus/apicommands.txt | nc -w 3 127.0.0.1 60000 | tr '{' '\n' | grep address | awk -F':' '{print $2 $5 $6 $10}' | sed 's/\"/ /g' | sed 's/  / /g' | awk -F',' '{print $1 $2 $3}' | sed 's/^.//'| tee tunneltmp.txt
        cat tunneltmp.txt | awk -F' ' '{print $1}' > /tmp/tunnelips.txt
        username=$(cat tunneltmp.txt | awk '{ print $(NF-0) }' > jamusers.tmp)
        echo "[-] Will be checking these IPs"
        cat /tmp/tunnelips.txt
else
        echo "[-] Tunnel is down"
        echo "$rightnow,Otunneldown,Otunneldown,Otunneldown,Otunneldown,Otunneldown,Otunneldown" | tee -a $outfile
        exit 1
fi
#
echo "[-] Parsing /tmp/tunnelips with IPInfo API key - outputs to $outfile"
echo
#echo "time,ipaddress,ASN,org,city,country,timezone" > $outfile
for loop in $(cat /tmp/tunnelips.txt)
do
        username=$(head -n1 jamusers.tmp)
        echo -e "$(sed '1d' jamusers.tmp)\n" > jamusers.tmp
        echo "[-] Checking IP Address $loop"
        curl -s "https://ipinfo.io/$loop/json?token=$key" > /tmp/ipinfo.parse
        sed -i 's/\"//g' /tmp/ipinfo.parse
        echo "[-] Getting user locations!"
        # Getting user locaton specifically here to get the location when the comma is beneficial to output
        # Following this info grab
        userlat=$(cat /tmp/ipinfo.parse | grep loc | awk -F':' '{print $2}' | cut -d',' -f1)
        userlong=$(cat /tmp/ipinfo.parse | grep loc | awk -F':' '{print $2}' | cut -d',' -f2)
        echo "[-] Coordinates of connected user are .... "
        echo "$rightnow,$username,$userlat,$userlong" | tee -a $locationfile
        # Now we can remove the uncessary commas from the tmp file curled from ipinfo.io
        sed -i 's/\,//g' /tmp/ipinfo.parse
        timezone=$(cat /tmp/ipinfo.parse | grep timezone | awk -F':' '{print $2}')
        country=$(cat /tmp/ipinfo.parse | grep country | awk -F':' '{print $2}')
        asn=$(cat /tmp/ipinfo.parse | grep org | awk -F':' '{print $2}' | cut -d' ' -f2)
        org=$(cat /tmp/ipinfo.parse | grep org | cut -d' ' -f3-)
        city=$(cat /tmp/ipinfo.parse | grep city | awk -F':' '{print $2}' | cut -d' ' -f2)
        echo "$rightnow,$loop,$asn,$org,$city,$country,$timezone" | tee -a $outfile
done
exit
rm -rf /tmp/ipinfo.parse
rm -rf /tmp/tunnelips.txt
rm -rf jamusers.tmp
