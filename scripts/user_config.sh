#!/bin/bash

USER_INPUT=1;

CUSTOMIZED_CONFIG_PATH="config/rc.conf"
DEFAULT_CONFIG_PATH="config/rc.conf.default"

echo ""
while read -p "Want to proceed with default config -- allinone?(yes/no) " REPLY1 ; do
  case $REPLY1 in
    yes)
    	echo ""
    	echo "--> Installing with the default config."
	# install with allinone

	# update the CONFIG_FILE_PATH to default 
	CONFIG_FILE_PATH=config/rc.conf.default
	
	break;;
    no) 
    	echo ""
    	echo "--> Checking if the customized config file is existed."
	if [ -f $CUSTOMIZED_CONFIG_PATH ]; then
		# the customized config file is existed
		echo ""
		echo "The customized config file is existed."
		
		echo ""
		while read -p "Install with the existed file?(yes/no) " REPLY2 ; do
  			case $REPLY2 in
  				yes) 
					echo ""
					echo "--> Installing with the existed config file."
					USER_INPUT=0;
					# install with the existed config file

					# update the CONFIG_FILE_PATH to user configured file 
					CONFIG_FILE_PATH=config/rc.conf

					break;;
				no)	
					break;;
				*) 
					echo ""
					echo "Please enter (yes) or (no).";;
			esac
		done
	else
		echo ""
		echo "The customized config file is not existed."
	fi

	if [ $USER_INPUT -eq 1 ]; then
			echo ""
			echo "--> Starting user input configuration."
			# user input configuration
			echo ""
			read -p "Please enter the network node IP (x.x.x.x): " NETWORK_IP
			echo ""
			read -p "Please enter the compute node IP (x.x.x.x): " COMPUTE_IP
			echo ""
			read -p "Please enter the controller node IP (x.x.x.x): " CONTROLLER_IP
			echo ""
			read -p "Please enter the storage node IP (x.x.x.x): " STORAGE_IP
			echo ""
			while read -p "Do you want to enable NOVA?(y/n)" NOVA_ENABLE ; do
				case $NOVA_ENABLE in
					y)	break;;
					n)	break;;
					*)	
						echo ""
						echo "Please enter y/n.";;
				esac
			done
			
			echo ""
			while read -p "Do you want to enable NEUTRON?(y/n)" NEUTRON_ENABLE ; do
				case $NEUTRON_ENABLE in
					y)	break;;
					n)	break;;
					*)	
						echo ""
						echo "Please enter y/n.";;
				esac
			done
			
			echo ""
			while read -p "Do you want to enable GLANCE?(y/n)" GLANCE_ENABLE ; do
				case $GLANCE_ENABLE in
					y)	break;;
					n)	break;;
					*)	
						echo ""
						echo "Please enter y/n.";;
				esac
			done
			
			echo ""
			while read -p "Do you want to enable HORIZON?(y/n)" HORIZON_ENABLE ; do
				case $HORIZON_ENABLE in
					y)	break;;
					n)	break;;
					*)	
						echo ""
						echo "Please enter y/n.";;
				esac
			done
			
			echo ""
			while read -p "Do you want to enable CINDER?(y/n)" CINDER_ENABLE ; do
				case $CINDER_ENABLE in
					y)	break;;
					n)	break;;
					*)	
						echo ""
						echo "Please enter y/n.";;
				esac
			done
			
			echo ""
			while read -p "Do you want to enable SWIFT?(y/n)" SWIFT_ENABLE ; do
				case $SWIFT_ENABLE in
					y)	break;;
					n)	break;;
					*)	
						echo ""
						echo "Please enter y/n.";;
				esac
			done

			echo ""
			cp $DEFAULT_CONFIG_PATH $DEFAULT_CONFIG_PATH".bkg"
			sed -i "s/^CONFIG_CONTROLLER_HOST.*$/CONFIG_CONTROLLER_HOST=$CONTROLLER_IP/g" $DEFAULT_CONFIG_PATH
			sed -i "s/^CONFIG_NETWORK_HOST.*$/CONFIG_NETWORK_HOST=$NETWORK_IP/g" $DEFAULT_CONFIG_PATH
			sed -i "s/^CONFIG_COMPUTE_HOST.*$/CONFIG_COMPUTE_HOST=$COMPUTE_IP/g" $DEFAULT_CONFIG_PATH
			sed -i "s/^CONFIG_STORAGE_HOST.*$/CONFIG_STORAGE_HOST=$STORAGE_IP/g" $DEFAULT_CONFIG_PATH

			sed -i "s/^CONFIG_NOVA_INSTALL.*$/CONFIG_NOVA_INSTALL=$NOVA_ENABLE/g" "$DEFAULT_CONFIG_PATH"
			sed -i "s/^CONFIG_NEUTRON_INSTALL.*$/CONFIG_NEUTRON_INSTALL=$NEUTRON_ENABLE/g" "$DEFAULT_CONFIG_PATH"
			sed -i "s/^CONFIG_GLANCE_INSTALL.*$/CONFIG_GLANCE_INSTALL=$GLANCE_ENABLE/g" "$DEFAULT_CONFIG_PATH"
			sed -i "s/^CONFIG_HORIZON_INSTALL.*$/CONFIG_HORIZON_INSTALL=$HORIZON_ENABLE/g" "$DEFAULT_CONFIG_PATH"
			sed -i "s/^CONFIG_CINDER_INSTALL.*$/CONFIG_CINDER_INSTALL=$CINDER_ENABLE/g" "$DEFAULT_CONFIG_PATH"
			sed -i "s/^CONFIG_SWIFT_INSTALL.*$/CONFIG_SWIFT_INSTALL=$SWIFT_ENABLE/g" "$DEFAULT_CONFIG_PATH"
			
			# update the CONFIG_FILE_PATH to config file 
			CONFIG_FILE_PATH=config/rc.conf
			
			# install with the default config file
			echo "--> Installing with the config file."

	fi
	break;;
    *) 
    	echo ""
    	echo "Please enter (yes) or (no).";;
  esac
done
