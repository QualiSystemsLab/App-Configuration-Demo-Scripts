# To run: 
# sudo ./install_ansible.sh <CS_HOST> <CS_USER> <CS_PASSWORD> <ES_NAME> <CS_VERSION>
# only cloudshell server is mandatory, the rest have defaults (admin, admin, linux-es-<server_ip>, 2022.1)
VERSION_2022_1=https://s3.amazonaws.com/quali-prod-binaries/2022.1.0.1851-184332/ES/cloudshell_es_install_script.sh
VERSION_2021_2=https://quali-prod-binaries.s3.amazonaws.com/2021.2.0.1673-182406/ES/cloudshell_es_install_script.sh
VERSION_2020_2=https://quali-prod-binaries.s3.amazonaws.com/2020.2.0.4142-182042/ES/cloudshell_es_install_script.sh

# Use positional command line args for manual execution, fallback to environment variables (for running from cloudshell)
CS_HOST="${1:$env:CS_HOST}"
CS_USER="${2:$env:CS_USER}"
CS_PASSWORD="${3:$env:CS_PASSWORD}"
ES_NAME="${4:$env:ES_NAME}"
CS_VERSION="${5:$env:CS_VERSION}"

# Validate inputs and set defaults
if [[ -z $CS_HOST ]]
then
  echo Cloudshell server is required param. Exiting.
  exit 1
fi

if [[ -z $CS_USER ]]
then
  $CS_USER=admin
fi

if [[ -z $CS_PASSWORD ]]
then
  $CS_PASSWORD=admin
fi

if [[ -z $ES_NAME ]]
then
  primary_ip=hostname -I
  $ES_NAME="ES-Linux-$primary_ip"
fi

if [[ -z $CS_VERSION ]]
then
  $CS_VERSION=2022.1
fi


SCRIPT_URL=""
# Get install url by lookup [2022.1, 2021.2, 2020.2] valid options. Empty input default to 2022.1
if [[ -z $CS_VERSION ]]
then
    $SCRIPT_URL=$VERSION_2022_1
elif [[ $CS_VERSION -eq 2022.1 ]]
then
  $SCRIPT_URL=$VERSION_2022_1
elif [[ $CS_VERSION -eq 2021.2 ]]
then
  $SCRIPT_URL=$VERSION_2021_2
elif [[ $CS_VERSION -eq 2021.2 ]]
then
  $SCRIPT_URL=$VERSION_2021_2
elif [[ $CS_VERSION -eq 2020.2 ]]
then
  $SCRIPT_URL=$VERSION_2020_2
else
  $CS_VERSION not supported by this script
  exit 1
fi


# Begin doing stuff
echo installing Cloudshell ES version $CS_VERSION
echo Script Url: $SCRIPT_URL

sudo wget $SCRIPT_URL
sudo chmod +x ./cloudshell_es_install_script.sh

echo "Got script. Starting ES install"
sudo ./cloudshell_es_install_script.sh $env:CS_HOST $env:CS_USER $env:CS_PASSWORD $env:ES_NAME

echo "upgrading pip to latest"
pip3 install --upgrade pip

echo "Installing Ansible"
sudo python3 -m pip install ansible

echo "Installing Pywinrm"
sudo python3 -m pip install pywinrm

echo "Yum installing SSH Pass"
sudo yum -y install sshpass