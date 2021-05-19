#!/bin/bash

# Install Python by Raf
# Example usage: ./install_python.sh 3.9

if [[ $EUID > 0 ]]; then
	echo "Please run as root."
	exit
fi

if  [ "$#" -ne 1 ]; then
	echo "Please run with target python version as argument"
	exit
fi

apt update
apt install software-properties-common
add-apt-repository ppa:deadsnakes/ppa
apt update
apt install python$1

apt install python3-pip
curl https://bootstrap.pypa.io/get-pip.py | python$1

ln -s /usr/bin/python$1 /usr/bin/python
ln -s /usr/bin/python /usr/bin/py
