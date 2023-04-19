# Check if user is root
if [ "$EUID" -eq 0 ]; then
    # Set prompt symbol for root user
    prompt_symbol=💀
    # Get the IP address of tun0 interface for root user
    tun0_ip=$(ifconfig tun0 2>/dev/null | grep -oP '(?<=inet\s)[\d.]+')
    # Get the IP address of eth0 interface if tun0 IP is not available for root user
    if [ -z "$tun0_ip" ]; then
        eth0_ip=$(ifconfig eth0 | grep -oP '(?<=inet\s)[\d.]+')
    fi
else
    # Set prompt symbol for non-root user
    prompt_symbol=㉿
    # Get the IP address of tun0 interface for non-root user
    tun0_ip=$(ifconfig tun0 2>/dev/null | grep -oP '(?<=inet\s)[\d.]+')
    # Get the IP address of eth0 interface if tun0 IP is not available for non-root user
    if [ -z "$tun0_ip" ]; then
        eth0_ip=$(ifconfig eth0 | grep -oP '(?<=inet\s)[\d.]+')
    fi
fi

# Set the left side of the prompt with username, hostname, and IP addresses
#left_prompt="%F{%(#.green.blue)}┌──${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}$username$prompt_symbol%m"
left_prompt="%F{%(#.green.blue)}┌──${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n$prompt_symbol%m"
if [ -n "$tun0_ip" ]; then
    left_prompt+=":$(tput sgr0)%B%F{green}$tun0_ip%F{reset}"
elif [ -n "$eth0_ip" ]; then
    left_prompt+=":$(tput sgr0)%B%F{yellow}$eth0_ip%F{reset}"
fi
left_prompt+="$(tput sgr0)%F{%(#.green.blue)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.green.blue)}]"$'\n'
# Set the right side of the prompt with the '#' symbol in red if the user is a superuser, or a '$' symbol in blue if the user is not a superuser
right_prompt="%F{%(#.green.blue)}└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} "

# Set the complete prompt with left and right side
PROMPT="${left_prompt}${right_prompt}"
