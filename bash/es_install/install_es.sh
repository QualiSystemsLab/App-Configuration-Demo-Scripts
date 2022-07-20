wget $env:SCRIPT_URL
chmod +x cloudshell_es_install_script.sh
./cloudshell_es_install_script $env:CS_HOST $env:CS_USER $env:CS_PASSWORD $env:ES_NAME
