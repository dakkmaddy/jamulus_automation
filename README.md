# jamulus_automation
Scripts and text files to keep Jamulus up and running on Cloud Servers

The script jamulusstart.sh is designed to be used with crontab to make sure the jamulus server is running and registered to the directory. It uses curl http://icanhazip.com to pull the public IP which is helpful for the when bouncing the service between cloud providers.

The text file "welcomejamulus.txt" is a simple welcome message that is called in the jamulusstart.txt
