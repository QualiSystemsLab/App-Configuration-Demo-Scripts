sudo wget $env:SCRIPT_URL
sudo chmod +x cloudshell_es_install_script.sh

echo "starting es install"
sudo ./cloudshell_es_install_script $env:CS_HOST $env:CS_USER $env:CS_PASSWORD $env:ES_NAME

echo "install ansible"
sudo python3 -m pip install ansible

echo "install pywinrm"
sudo python3 -m pip install pywinrm

echo "install ssh pass"
sudo yum install sshpass