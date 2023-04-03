#!/bin/bash

# Bash script for initializing the Wordpress installation on EC2 instances

# Mounts Elastic File System (EFS) to /var/www directory
MOUNT_PATH="/var/www"
EFS_DNS_NAME=${vars.efs_dns_name}

# Check if the EFS is already mounted, if not, mount it
[ $(grep -c $${EFS_DNS_NAME} /etc/fstab) -eq 0 ] && \
        (echo "$${EFS_DNS_NAME}:/ $${MOUNT_PATH} nfs nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0" >> /etc/fstab; \
                mkdir -p $${MOUNT_PATH}; mount $${MOUNT_PATH})

# Installs necessary packages and configurations
yum -y update
amazon-linux-extras enable php7.4
yum -y install httpd mod_ssl php php-cli php-gd php-mysqlnd

# Configure Apache to work behind a load balancer
echo -e '<IfModule mod_setenvif.c>\n\tSetEnvIf X-Forwarded-Proto "^https$" HTTPS\n</IfModule>' > /etc/httpd/conf.d/xforwarded.conf

# Configure PHP settings
sed -i 's/post_max_size = 8M/post_max_size = 128M/g'  /etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 128M/g'  /etc/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 600/g'  /etc/php.ini
sed -i 's/; max_input_vars = 1000/max_input_vars = 2000/g'  /etc/php.ini
sed -i 's/max_input_time = 60/max_input_time = 300/g'  /etc/php.ini

# Enable and start the Apache service
systemctl enable --now httpd

# Open necessary ports in the firewall
firewall-cmd --add-service=http
firewall-cmd --add-service=https
firewall-cmd --runtime-to-permanent

# Download and configure Wordpress
WP_ROOT_DIR=$${MOUNT_PATH}/html
LOCK_FILE=$${MOUNT_PATH}/.wordpress.lock
EC2_LIST=$${MOUNT_PATH}/.ec2_list
WP_CONFIG_FILE=$${WP_ROOT_DIR}/wp-config.php

SHORT_NAME=$(hostname -s)

# Add the instance's hostname to the list of instances for future reference
echo "$${SHORT_NAME}" >> $${EC2_LIST}

# If this is the first instance and there is no lock file, download and configure Wordpress
FIRST_SERVER=$(head -1 $${EC2_LIST})

if [ ! -f $${LOCK_FILE} -a "$${SHORT_NAME}" == "$${FIRST_SERVER}" ]; then

	# Create lock file to avoid multiple attempts to download and configure Wordpress
	touch $${LOCK_FILE}

	# Add an index.html file for ALB health checks during initialization
	echo "OK" > $${WP_ROOT_DIR}/index.html

    # Download and extract the latest version of Wordpress
    cd $${MOUNT_PATH}
    wget http://wordpress.org/latest.tar.gz
    tar xzvf latest.tar.gz
    rm -rf $${WP_ROOT_DIR}
    mv wordpress html
    mkdir $${WP_ROOT_DIR}/wp-content/uploads

    # Set correct permissions for Apache to access Wordpress files and directories
    chown -R apache /var/www
    chgrp -R apache /var/www
    chmod 2775 /var/www
    find /var/www -type d -exec sudo chmod 2775 {} \;
    find /var/www -type f -exec sudo chmod 0664 {} \;

    # Cleanup install file
    rm -rf latest.tar.gz

else
	echo "$(date) :: Lock is acquired by another server"  >> /var/log/user-data-status.txt
fi

# Reboot
reboot