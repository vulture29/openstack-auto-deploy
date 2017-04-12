#!/bin/bash

USER_INPUT=1;
CUSTOMIZED_CONFIG_PATH="/Users/macbook/Desktop/answer_customized.txt"
DEFAULT_CONFIG_PATH="/home/xhuang17/OpenStackonaStick/answer.txt"
echo "CUSTOMIZED_CONFIG_PATH is " $CUSTOMIZED_CONFIG_PATH
while read -p "Want to proceed with default config -- allinone?(yes/no) " REPLY1 ; do
  case $REPLY1 in
    yes) echo "Installing with the default config..."
	# install with allinone

	break;;
    no) echo "Checking if the customized config file is existed..."
	if [ -f $CUSTOMIZED_CONFIG_PATH ]; then
		# the customized config file is existed
		echo "The customized config file is existed."
		while read -p "Install with the existed file?(yes/no) " REPLY2 ; do
  			case $REPLY2 in
  				yes) echo "Installing with the existed config file..."
				USER_INPUT=0;
				# install with the existed config file

				break;;
				no)	break;;
				*) echo "Please enter (yes) or (no).";;
			esac
		done
	else
		echo "The customized config file is not existed."
	fi
	if [ $USER_INPUT -eq 1 ]; then
			echo "Starting user input configuration..."
			# user input configuration
			read -p "Please enter the network node IP (x.x.x.x): " NETWORK_IP
			read -p "Please enter the conpute node IP (x.x.x.x): " COMPUTE_IP
			read -p "Please enter the controller node IP (x.x.x.x): " CONTROLLER_IP
			read -p "Please enter the storage node IP (x.x.x.x): " STORAGE_IP
			while read -p "Do you want to enable NOVA?(y/n)" NOVA_ENABLE ; do
				case $NOVA_ENABLE in
					y)	break;;
					n)	break;;
					*)	echo "Please enter y/n.";;
				esac
			done
			while read -p "Do you want to enable NEUTREN?(y/n)" NEUTREN_ENABLE ; do
				case $NEUTREN_ENABLE in
					y)	break;;
					n)	break;;
					*)	echo "Please enter y/n.";;
				esac
			done
			while read -p "Do you want to enable GLANCE?(y/n)" GLANCE_ENABLE ; do
				case $GLANCE_ENABLE in
					y)	break;;
					n)	break;;
					*)	echo "Please enter y/n.";;
				esac
			done
			while read -p "Do you want to enable HORIZON?(y/n)" HORIZON_ENABLE ; do
				case $HORIZON_ENABLE in
					y)	break;;
					n)	break;;
					*)	echo "Please enter y/n.";;
				esac
			done
			while read -p "Do you want to enable CINDER?(y/n)" CINDER_ENABLE ; do
				case $CINDER_ENABLE in
					y)	break;;
					n)	break;;
					*)	echo "Please enter y/n.";;
				esac
			done
			while read -p "Do you want to enable SWIFT?(y/n)" SWIFT_ENABLE ; do
				case $SWIFT_ENABLE in
					y)	break;;
					n)	break;;
					*)	echo "Please enter y/n.";;
				esac
			done

			cp $DEFAULT_CONFIG_PATH $DEFAULT_CONFIG_PATH".bkg"
			sed -i "s/^CONFIG_CONTROLLER_HOST.*$/CONFIG_CONTROLLER_HOST=$CONTROLLER_IP/g" $DEFAULT_CONFIG_PATH
			sed -i "s/^CONFIG_NETWORK_HOST.*$/CONFIG_NETWORK_HOST=$NETWORK_IP/g" $DEFAULT_CONFIG_PATH
			sed -i "s/^CONFIG_COMPUTE_HOST.*$/CONFIG_COMPUTE_HOST=$COMPUTE_IP/g" $DEFAULT_CONFIG_PATH
			sed -i "s/^CONFIG_STORAGE_HOST.*$/CONFIG_STORAGE_HOST=$STORAGE_IP/g" $DEFAULT_CONFIG_PATH

			sed -i "s/^CONFIG_NOVA_INSTALL.*$/CONFIG_NOVA_INSTALL=$NOVA_ENABLE/g" "$DEFAULT_CONFIG_PATH"
			sed -i "s/^CONFIG_NEUTREN_INSTALL.*$/CONFIG_NEUTREN_INSTALL=$NEUTREN_ENABLE/g" "$DEFAULT_CONFIG_PATH"
			sed -i "s/^CONFIG_GLANCE_INSTALL.*$/CONFIG_GLANCE_INSTALL=$GLANCE_ENABLE/g" "$DEFAULT_CONFIG_PATH"
			sed -i "s/^CONFIG_HORIZON_INSTALL.*$/CONFIG_HORIZON_INSTALL=$HORIZON_ENABLE/g" "$DEFAULT_CONFIG_PATH"
			sed -i "s/^CONFIG_CINDER_INSTALL.*$/CONFIG_CINDER_INSTALL=$CINDER_ENABLE/g" "$DEFAULT_CONFIG_PATH"
			sed -i "s/^CONFIG_SWIFT_INSTALL.*$/CONFIG_SWIFT_INSTALL=$SWIFT_ENABLE/g" "$DEFAULT_CONFIG_PATH"
			
			# install with the default config file
			echo "Installing with the config file..."

	fi
	break;;
    *) echo "Please enter (yes) or (no).";;
  esac
done
