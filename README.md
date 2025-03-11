# jamulus_automation
Scripts and text files to keep Jamulus up and running on Cloud Servers. 

The script jamulusstart.sh is designed to be used with crontab to make sure the jamulus server is running and registered to the directory. It uses curl http://icanhazip.com to pull the public IP which is helpful for the when bouncing the service between cloud providers. Store this in /usr/local/sbin so it is in the default path.

The text file "welcomejamulus.txt" is a simple welcome message that is called in the jamulusstart.txt. The text file is /srv/Jamulus

The text file rpcsecret.txt is OPTIONAL and also in /srv/Jamulus. This can literally contain anything (right now it just has the word placeholder). This allows the remote Ansible server to run API queries via SSH tunnel. The JSON Jamulus API is not exposed to the internet by default. This file is called by jamulusstart.sh on the jamulus start up command. This file is kept in /srv/Jamulus
