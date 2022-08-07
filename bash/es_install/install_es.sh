VERSION_2022_1 = https://s3.amazonaws.com/quali-prod-binaries/2022.1.0.1851-184332/ES/cloudshell_es_install_script.sh
VERSION_2021_2 = https://quali-prod-binaries.s3.amazonaws.com/2021.2.0.1673-182406/ES/cloudshell_es_install_script.sh
VERSION_2020_2 = https://quali-prod-binaries.s3.amazonaws.com/2020.2.0.4142-182042/ES/cloudshell_es_install_script.sh

CS_VERSION = $env:CS_VERSION
SCRIPT_URL = ""

if [[ -z $CS_VERSION ]]
then
    $SCRIPT_URL = $VERSION_2022_1
elif [[ $CS_VERSION -eq 2022.1 ]]
then
  $SCRIPT_URL = $VERSION_2022_1
elif [[ $CS_VERSION -eq 2021.2 ]]
then
  $SCRIPT_URL = $VERSION_2021_2
elif [[ $CS_VERSION -eq 2021.2 ]]
then
  $SCRIPT_URL = $VERSION_2021_2
elif [[ $CS_VERSION -eq 2020.2 ]]
then
  $SCRIPT_URL = $VERSION_2020_2
else
  $CS_VERSION not supported by this script
  exit 1
fi

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