#!/usr/bin/env bash

if [ -z ${DIR+x} ]; then 
	#running by itself
	source ../../constants.sh
else 
	#running from dendro_full_setup_ubuntu_server_ubuntu_16.sh
	source ./constants.sh
fi

#save current dir
setup_dir=$(pwd)

printf "${Cyan}[INFO]${Color_Off} Stopping ${dendro_service_name} service...\n"
sudo systemctl stop $dendro_service_name

#check out dendro code from svn repo
printf "${Cyan}[INFO]${Color_Off} Installing Dendro to path : ${dendro_installation_path}\n"
sudo rm -rf $dendro_installation_path
cd $temp_downloads_folder
printf "${Cyan}[INFO]${Color_Off} Exporting Dendro from code repository at : ${dendro_svn_url} to $dendro_installation_path. PLEASE STAND BY!\n"
sudo svn -q --no-auth-cache export $dendro_svn_url $dendro_installation_path --username $svn_user --password $svn_user_password --force

#give "dendro" user ownership of the installation
sudo chown -R $dendro_user_name:$dendro_user_group $installation_path
sudo chmod -R 0755 $installation_path

#set active deployment configuration
sudo npm --prefix $dendro_installation_path install $dendro_installation_path
echo "{\"key\" : \"${active_deployment_setting}\"}" | sudo tee $dendro_installation_path/deployment/active_deployment_config.json

#go back to initial dir
cd $setup_dir
