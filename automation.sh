#!/bin/bash
s3_bucket="upgrad-saneeka"
name="Saneeka"
timestamp=$(date '+%d%m%Y-%H%M%S')
sudo apt update -y
sudo apt install apache2
sudo systemctl start apache2
sudo systemctl enable apache2
sudo tar cvf /tmp/${name}-httpd-logs-${timestamp}.tar.gz /var/log/apache2/*.log
aws s3 cp /tmp/${name}-httpd-logs-${timestamp}.tar.gz s3://${s3_bucket}/${name}-httpd-logs-${timestamp}.tar.gz

if [ ! -f /var/www/html/inventory.html ] ;
then
        sudo touch /var/www/html/inventory.html
                sudo echo "Log Type        Date Created       Type       Size" > /var/www/html/inventory.html ;
fi

logtype="httpd-logs"
datecreated=$(ls -lrth /tmp | grep -i "tar" | awk -F "-" '{print $10"-"$11}' | sed 's/\.tar\.gz//')
filetype="tar"
size=$(ls -lrth /tmp | grep -i "tar" | awk -F " " '{print $5}')

sudo echo "$logtype        $datecreated       $filetype        $size" >> /var/www/html/inventory.html

sudo rm -rf /tmp/*.tar.gz

if [ ! -f /etc/cron.d/automation ] ;
then
        sudo touch /etc/cron.d/automation
                sudo echo '* 10 * * *  root /root/Automation_Project/automation.sh' > /etc/cron.d/automation;
fi
