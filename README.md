# lxd-group-privilege-escalation
Script to elevate your privilege if you are in the group 'lxd'.

## How to execute
1 -> Clone this repository with: ```git clone https://github.com/David132435/lxd-group-privilege-escalation```  
2 -> Navigate to the folder: ```cd lxd-group-privilege-escalation```  
3 -> Give the script execute permission: ```chmod +x lxdprivesc.sh```  
4 -> Execute the script and see help: ```./lxdprivesc.sh```

![image](https://github.com/David132435/lxd-group-privilege-escalation/assets/106914229/d4a2f350-8bfc-499e-8e87-2e47d79b635d)



5 ->  Execute it with ```./lxdprivesc.sh --run```

![image](https://github.com/David132435/lxd-group-privilege-escalation/assets/106914229/b0265f74-3675-411a-a69d-c3db54f1c3f0)


6 -> You can see that after executing it, bash is now SUID and the user that executed the script can now run any command with sudo without password

![image](https://github.com/David132435/lxd-group-privilege-escalation/assets/106914229/b56e83cc-8519-404a-ac5a-2ca71532e091)


7 -> After exploitation, you can remove the container and image with ```./lxdprivesc.sh --clean```

![image](https://github.com/David132435/lxd-group-privilege-escalation/assets/106914229/ada5d9de-7dba-4a7e-9ffe-1110cc6c2cba)


Enjoy! 😊
-----------------------------
(Tested on Ubuntu 22.04)
