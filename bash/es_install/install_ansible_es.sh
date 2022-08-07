#!/bin/sh
# To run:
# sudo ./install_ansible.sh <CS_HOST> <CS_USER> <CS_PASSWORD> <ES_NAME> <CS_VERSION>
# only cloudshell server is mandatory, the rest have defaults (admin, admin, linux-es-<server_ip>, 2022.1)
VERSION_2022_1="https://s3.amazonaws.com/quali-prod-binaries/2022.1.0.1851-184332/ES/cloudshell_es_install_script.sh"
VERSION_2021_2="https://quali-prod-binaries.s3.amazonaws.com/2021.2.0.1673-182406/ES/cloudshell_es_install_script.sh"
VERSION_2020_2="https://quali-prod-binaries.s3.amazonaws.com/2020.2.0.4142-182042/ES/cloudshell_es_install_script.sh"

# Use positional command line args for manual execution, fallback to environment variables (for running from cloudshell)
CS_HOST=${1:-$CS_HOST}
CS_VERSION=${2:-$CS_VERSION}
CS_USER=${3:-$CS_USER}
CS_PASSWORD=${4:-$CS_PASSWORD}
ES_NAME=${5:-$ES_NAME}

# Validate inputs and set defaults
if [ -z "${CS_HOST}" ]
then
    echo "Cloudshell server param is required. Exiting."
    exit 1
fi
if [ -z "${CS_USER}" ]
then
    CS_USER="admin"
fi
if [ -z "${CS_PASSWORD}" ]
then
    CS_PASSWORD="admin"
fi
if [ -z "${ES_NAME}" ]
then
    primary_ip=$(hostname -I)
    ES_NAME="ES-Linux-$primary_ip"
fi
if [ -z "${CS_VERSION}" ]
then
    CS_VERSION="2022.1"
fi


SCRIPT_URL=""
# Get install url by lookup [2022.1, 2021.2, 2020.2] valid options. Empty input default to 2022.1
if [ -z $CS_VERSION ]
then
    SCRIPT_URL=$VERSION_2022_1
elif [ $CS_VERSION = "2022.1" ]
then
    SCRIPT_URL=$VERSION_2022_1
elif [ $CS_VERSION = "2021.2" ]
then
    SCRIPT_URL=$VERSION_2021_2
elif [ $CS_VERSION = "2021.2" ]
then
    SCRIPT_URL=$VERSION_2021_2
elif [ $CS_VERSION = "2020.2" ]
then
    SCRIPT_URL=$VERSION_2020_2
else
    echo "$CS_VERSION not supported by this script. Exiting."
    exit 1
fi


# Begin doing stuff
echo "installing Cloudshell ES version $CS_VERSION"

if [ ! -f ./cloudshell_es_install_script.sh ]
then
    echo "Download Script from url: $SCRIPT_URL"
    sudo wget $SCRIPT_URL
    sudo chmod +x ./cloudshell_es_install_script.sh
fi

# don't stop on failed install, print exit code and continue with ansible install
echo "Starting ES install"
set -e
EXIT_CODE=0
sudo ./cloudshell_es_install_script.sh "$CS_HOST" "$CS_USER" "$CS_PASSWORD" "$ES_NAME" >/dev/null || EXIT_CODE=$?
echo "ES install completed with exit code: $EXIT_CODE"

echo "Validate ES Status:"
EXIT_CODE=0
sudo systemctl status es.service || EXIT_CODE=$?
echo "ES status code: $EXIT_CODE"

echo "upgrading pip to latest"
EXIT_CODE=0
sudo python3 -m pip install --upgrade pip >/dev/null || EXIT_CODE=$?
echo "Upgrade pip completed with exit code: $EXIT_CODE"

echo "Installing Ansible"
EXIT_CODE=0
sudo python3 -m pip install ansible >/dev/null || EXIT_CODE=$?
echo "Install Ansible completed with exit code: $EXIT_CODE"

echo "Installing Pywinrm"
sudo python3 -m pip install pywinrm

echo "Yum installing SSH Pass"
sudo yum -y install sshpass

echo "Ansible ES script Complete!"