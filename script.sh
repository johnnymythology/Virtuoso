#!/bin/bash
clear

echo "Welcome to Virtuoso! Created by Johnny"
echo ""
echo "PLEASE RUN WITH SYSTEM PRIVILEGE"
echo ""
echo "All in one penetration tool for penetration testing!"
echo "Please enter your target IP address"
echo "Please input one IP address ONLY!" 
read -p 'Target IP Address> ' ip


IFS='.' read -r -a array <<< "$ip"

if [ ${#array[@]} -eq 4 ]
then
	for element in "${array[@]}"
	do
		
   		if [[ $element -lt 0 ]] || [[ $element -gt 255 ]]
		then
			echo "IP Address Error, try again!"
			exit 0
	
		fi
	
	done
else
	echo "Sorry the IP address is Invalid!"
	exit 0
fi

echo "Masking your identity"
echo "Your current Public IP address"
dig +short myip.opendns.com @resolver1.opendns.com
echo "Your current Private IP address"
ifconfig | grep "inet" | cut -d":" -f 2   
echo "Would you like to mask your identity?[y/n]"
read option
if [ $option == "y" ]
then
	while :
	do
		echo "[1] proxychains (Ensure you have it configured!)"
		echo "[2] ip changer (host only!)"
		echo "[3] macchangr (host only!)"
		echo "[4] Skip to Reconnaissance"
		echo "[5] Quit"
	read -p 'Virtuoso> ' option

	case $option in 
                1)
		echo "Proxychains Selected"
		echo "All command from now onwards will run with Proxychains!"
		proxychains="y"
		echo "Would you like to continue or do another option? [y/n]"
		read option
		if [ $option == 'n' ]
		then
			break
		fi
		;;
     	2)
		echo "ip changer Selected"
		ifconfig | grep "mtu" | cut -d":" -f 1
		echo "Please type in the interface name:"
		read -p "interface> " interface
		echo "Please type in the spoofed IP address:"
		read -p "spoofed ip address> "ip
		ifconfig $interface $ip
		echo "Please confirm your changes:"
		ifconfig | grep "inet" | cut -d":" -f 2  
		echo "Would you like to continue or do another option? [y/n]"
        	read option
        	if [ $option == 'n' ]
        	then
                	break
        	fi
		;;
     	3)
		echo "macchanger Selected"
		ifconfig | grep "mtu" | cut -d":" -f 1
		ifconfig | grep "ether" 
                echo "Please type in the interface name:"
                read -p "interface> " interface
                echo "Randomizing MAC address"
		ifconfig $interface down
                macchanger -r $interface
		ifconfig $interface up
                echo "Please confirm your changes:"
                ifconfig | grep "ether" 
		echo "Would you like to continue or do another option? [y/n]"
        	read option
        	if [ $option == 'n' ]
        	then
                	break
        	fi
		;;
     	5)
		echo "Quiting Now"
		exit 0
		;;
	esac

	done
fi	



while :
do
echo "Now to the reconnaissance phase"
echo "[1] Whois"
echo "[2] dig"
echo "[3] theHarvester"
echo "[4] Skip to Scanning"
echo "[5] Quit"
read -p 'Virtuoso> ' option

case $option in 
     1)
	echo "Whois Selected"
	echo "Running Whois Now"
	if [ $proxychains == "y" ]
	then
		proxychains whois $ip
	else 
		whois $ip
	fi
	echo "Would you like to continue or do another recon? [y/n]"
	read option
	if [ $option == 'n' ]
	then
		break
	fi
	;;
     2)
	echo "dig Selected"
	echo "Running dig Now"
	dig $ip
	echo "Would you like to continue or do another recon? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
	;;
     3)
	echo "theHarvester Selected (Only Google)"
	echo "Running theHarvester"
	if [ $proxychains == "y" ]
        then
                proxychains theharvester -d $ip -b google
        else 
                theharvester -d $ip -b google
        fi
	echo "Would you like to continue or do another recon? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
	;;
     5)
	echo "Quiting Now"
	exit 0
	;;
esac

done

while :
do
echo "Now to the scanning phase"
echo "[1] nmap"
echo "[2] netdiscover"
echo "[3] masscan (For large network)"
echo "[4] Skip to Exploitation"
echo "[5] Quit"
read -p 'Virtuoso> ' option

case $option in 
     1)
	echo "nmap Selected"
	echo "It will find the OS and services running"
	echo "What is the IP address and the range (192.168.0.0/24)"
	read -p"ipaddress> " ipaddr
	echo "What is the scan that you would like to perform (sT)"
	read -p"Type> " type
	echo "What is the intensity of Scan?"
	read -p"Intensity> " intensity
	if [ $proxychains == "y" ]
        then
                proxychains nmap -$type -t $intensity -O -sV $ipaddr
        else 
                nmap -$type -t $intensity -O -sV $ipaddr
        fi

	echo "Would you like to continue or do another recon? [y/n]"
	read option
	if [ $option == 'n' ]
	then
		break
	fi
	;;
     2)
	echo "netdiscover Selected"
	echo "Running netdiscover Now"
	if [ $proxychains == "y" ]
        then
                proxychains netdiscover 
        else 
                netdiscover
        fi
	echo "Would you like to continue or do another recon? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
	;;
     3)
	echo "theHarvester Selected"
	echo "Running theHarvester"
	if [ $proxychains == "y" ]
        then
                proxychains whois $ip
        else 
                whois $ip
        fi

	echo "Would you like to continue or do another recon? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
	;;
     5)
	echo "Quiting Now"
	exit 0
	;;
esac

done

while :
do
echo "Now to the Exploitation phase"
echo "[1] metasploit"
echo "[2] dig"
echo "[3] theHarvester"
echo "[4] Skip to Scanning"
echo "[5] Quit"
read -p 'Virtuoso> ' option

case $option in 
     1)
	echo "Whois Selected"
	echo "Running Whois Now"
	if [ $proxychains == "y" ]
        then
                proxychains whois $ip
        else 
                whois $ip
        fi
	echo "Would you like to continue or do another recon? [y/n]"
	read option
	if [ $option == 'n' ]
	then
		break
	fi
	;;
     2)
	echo "dig Selected"
	echo "Running dig Now"
	if [ $proxychains == "y" ]
        then
                proxychains whois $ip
        else 
                whois $ip
        fi
	echo "Would you like to continue or do another recon? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
	;;
     3)
	echo "theHarvester Selected"
	echo "Running theHarvester"
	if [ $proxychains == "y" ]
        then
                proxychains whois $ip
        else 
                whois $ip
        fi
	echo "Would you like to continue or do another recon? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
	;;
     5)
	echo "Quiting Now"
	exit 0
	;;
esac

done

        




