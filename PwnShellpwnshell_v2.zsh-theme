# Check if user is root
if [ "$EUID" -eq 0 ]; then

    # Get the IP address of tun0 interface for root user
    tun0_ip=$(ifconfig tun0 2>/dev/null | grep -oP '(?<=inet\s)[\d.]+')
    # Get the IP address of eth0 interface if tun0 IP is not available for root user
    if [ -z "$tun0_ip" ]; then
        eth0_ip=$(ifconfig eth0 | grep -oP '(?<=inet\s)[\d.]+')
    fi
else

    # Get the IP address of tun0 interface for non-root user
    tun0_ip=$(ifconfig tun0 2>/dev/null | grep -oP '(?<=inet\s)[\d.]+')
    # Get the IP address of eth0 interface if tun0 IP is not available for non-root user
    if [ -z "$tun0_ip" ]; then
        eth0_ip=$(ifconfig eth0 | grep -oP '(?<=inet\s)[\d.]+')
    fi
fi


left_prompt="%F{green}┌──${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%F{%(#.red.blue)}%n"
if [ -n "$tun0_ip" ]; then
    network_symbol=🔒
    left_prompt+=" $network_symbol $(tput sgr0)%F{yellow}$tun0_ip%F{reset}"
elif [ -n "$eth0_ip" ]; then
    network_symbol=💻
    left_prompt+=" $network_symbol $(tput sgr0)%F{yellow}$eth0_ip%F{reset}"
fi
left_prompt+="$(tput sgr0)%F{green})-[%F{reset}%(6~.%-1~/…/%4~.%5~)%F{green}]"$'\n'

right_prompt="%F{green}└─❯%F{reset} "
# Set the complete prompt with left and right side
PROMPT="${left_prompt}${right_prompt}"
