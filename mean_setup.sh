#!/bin/bash

echo "Setting up MEAN Stack.."
echo "NodeJS installation initiated.."

# Taking version choice
echo -en "For LTS press y | For latest version press n ? [y/n] "  
read CHOICE

# Checking PPA
if [ $CHOICE = "y" ]; then
 echo "LTS version will be added as a PPA"
 curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
 elif [ $CHOICE = "n" ]; then
  echo "Latest version will be added as a PPA"
  curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
 else
  echo "Invalid input.....Terminating Script"
  exit 130
fi

echo "Preparing to install NodeJS..."

sudo apt-get update

#Installing node PPA version

sudo apt-get install -y nodejs

echo "NodeJS [`node -v`] installed..."

#Update NPM
echo "Updating NPM version from [`npm -v`] "

sudo npm install -g npm

echo "Updated npm to [`npm -v`] "

#Install grunt-cli,bower
echo "Installing bower,grunt-cli,gulp-cli..."

sudo npm install -g bower grunt-cli gulp-cli

echo "Installed bower [`bower -v`], grunt-cli, gulp-cli..."

#MongoDB installation
echo "Initiating MongoDB installation.."
echo "Importing public key.."

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6

echo "Creating the sources list file according to the OS code"

echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list

echo "Updating package versions"

sudo apt-get update

echo "Installing mongodb-server.."

sudo apt-get install -y mongodb-org

echo "Creating file to manage service.."

echo "[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target

[Service]
User=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/mongodb.service

echo "Staring mongod instance.."

sudo systemctl start mongodb

echo "Enabling serice on boot..."

sudo systemctl enable mongodb

echo "Successfully installed MEAN Stack...Exiting Script...Bye!"

