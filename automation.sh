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