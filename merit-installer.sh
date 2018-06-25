#!/bin/bash

numcores=$(cat /proc/cpuinfo | grep processor | wc -l)
if [[ $(grep avx2 /proc/cpuinfo) ]]; then 
    configstring="-O3 -mavx2"; 
elif [[ $(grep avx /proc/cpuinfo) ]]; then     
    configstring="-O2 -mavx"; 
else 
    configstring="-O2"; 
fi

# install merit miner on ubuntu
# created by AkiAfroo
cd /home/$USER
mkdir -p /home/$USER/merit/
#meritfolder="cd /home/$USER/merit/"
merit=/home/$USER/merit-miner
#if ping -c 1 google.com > /dev/null 2>&1 then
if [ ! -f $merit/minerd ]; then
					
					sudo apt-get update
					sudo apt-get install git libcurl4-openssl-dev libboost-all-dev build-essential libtool automake autotools-dev libboost-dev -y
					git clone https://github.com/meritlabs/merit-miner.git	
					cd $merit
					clear
					echo "now lets have fun compiling!."
					sleep 3
					./autogen.sh
					./nomacro.pl
					CFLAGS=${configstring} CXXFLAGS=${configstring} ./configure
					make -j${numcores}
					chmod +x minerd
					clear
					echo "Merit Miner was compiled!"
					sleep 2					
fi	
			
	cd $merit
	read -p "Please type your Merit address or Alias: " nickname
	if [[ -z "$nickname" ]]; then
	printf '%s\n' "No input entered"
	exit 1
	else
	/$merit/minerd -o stratum+tcp://pool.merit.me:3333 -u $nickname -t ${numcores} -C 2					
	fi							
exit 0		
