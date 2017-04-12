#!/bin/bash

USER_INPUT=1;
CUSTOMIZED_CONFIG_PATH="/Users/macbook/Desktop/flow.jpeg"
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
				*) "Please enter (yes) or (no).";;
			esac
		done
	else
		echo "The customized config file is not existed."
	fi
	if [ $USER_INPUT -eq 1 ]; then
			echo "Starting user input configuration..."
			# user input configuration

	fi
	break;;
    *) echo "Please enter (yes) or (no).";;
  esac
done