#!/bin/bash

# Software_Deployment.sh
# Author: David Findley
# https://github.com/davidfindley19/Linux-Scripts/
#
# This scripts purpose is to install the missing development software on engineering Linux machines from the internal APT repo. 
# The software can be changed out in the script, but it checks to see if it's installed and then installs if not. 

echo "Engineering Linux Machine Deployment"

#We need verification that user is running this script as root.
if [ "$USER" != "root" ]; then
	echo "You are attempting to execute this process as user $USER"
	echo "Please execute the script with elevated permissions."
	exit 1
fi

# To ensure that all package lists are up to date. This is set to update the packages silenty unless there 
# are any errors. 
apt-get -qq -y update

# The script will now perform an aptitude search for the package(s) and install if not found.
if (!(aptitude search chrpath | grep ^i)); then
	# The following command outputs the text for the chrpath install to a text file for a cleaner install experience. If there are any errors, they'll be saved here.
	apt-get install chrpath 2> /tmp/charpathinstall.txt
	if (aptitude search chrpath | grep ^i); then
		echo "CHRPATH INSTALLED CORRECTLY"
	else 
		echo "CHRPATH DID NOT INSTALL CORRECTLY"
	fi
else 
	echo "chrpath is already installed - Please see error log in the tmp folder."
fi

# The following section will install gawk.
if (!(aptitude search gawk | grep ^i)); then
	apt-get install gawk 2> /tmp/gawkinstall.txt
	if (aptitude search gawk | grep ^i); then
		echo "GAWK INSTALLED CORRECTLY"
	else 
		echo "GAWK DID NOT INSTALL CORRECTLY - Please see error log in the tmp folder."
	fi
else 
	echo "GAWK is already installed"
fi

# This section will install texinfo.
if (!(aptitude search texinfo | grep ^i)); then
	apt-get install -y texinfo 2> /tmp/texinfoinstall.txt
	if (aptitude search chrpath | grep ^i); then
		echo "CHRPATH INSTALLED CORRECTLY"
	else 
		echo "CHRPATH DID NOT INSTALL CORRECTLY - Please see error log in the tmp folder."
	fi
else 
	echo "chrpath is already installed"
fi

# This section will install g++
if (!(aptitude search g++ | grep ^i)); then
	apt-get install -y g++ 2> /tmp/g++install.txt
	if (aptitude search g++ | grep ^i); then
		echo "G++ INSTALLED CORRECTLY"
	else 
		echo "G++ DID NOT INSTALL CORRECTLY - Please see error log in the tmp folder."
	fi
else 
	echo "G++ is already installed"
fi

# This section will install build-essential
if (!(aptitude search build-essential | grep ^i)); then
	apt-get install -y build-essential 2> /tmp/build-essentialinstall.txt
	if (aptitude search chrpath | grep ^i); then
		echo "BUILD-ESSENTIAL INSTALLED CORRECTLY"
	else 
		echo "BUILD-ESSENTIAL DID NOT INSTALL CORRECTLY - Please see error log in the tmp folder."
	fi
else 
	echo "build-essential is already installed"
fi

# This section will install gcc-multilib
if (!(aptitude search gcc-multilib | grep ^i)); then
	apt-get install -y gcc-multilib 2> /tmp/gccmultilibinstall.txt
	if (aptitude search gcc-multilib | grep ^i); then
		echo "GCC-MULTILIB INSTALLED CORRECTLY"
	else 
		echo "GCC-MULTILIB DID NOT INSTALL CORRECTLY - Please see error log in the tmp folder."
	fi
else 
	echo "gcc-multilib is already installed"
fi

# This section will install the dos2unix module.
if (!(aptitude search dos2unix | grep ^i)); then
	apt-get install -y dos2unix 2> /tmp/dos2unixinstall.txt
	if (aptitude search dos2unix | grep ^i); then
		echo "DOS2UNIX INSTALLED CORRECTLY"
	else 
		echo "DOS2UNIX DID NOT INSTALL CORRECTLY - Please see error log in the tmp folder."
	fi
else 
	echo "dos2unix is already installed"
fi

if (!(aptitude search libncurses5-dev | grep ^i)); then
	apt-get install -y libncurses5-dev 2> /tmp/libncurses5install.txt
	if (aptitude search libncurses5-dev | grep ^i); then
		echo "LIBNCURSES5-DEV INSTALLED CORRECTLY"
	else 
		echo "LIBNCURSES5-DEV DID NOT INSTALL CORRECTLY - Please see error log in the tmp folder."
	fi
else 
	echo "libncurses5-dev is already installed"
fi

nyancat
