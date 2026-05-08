#!/bin/bash

# Clear screen for clean look
clear
echo -e "\e[1;36m====================================================\e[0m"
echo -e "\e[1;32m      Welcome to Terminal Banner Setup\e[0m"
echo -e "\e[1;36m====================================================\e[0m"

# Read inputs directly from /dev/tty so it works with curl | bash
read -p "Enter your Terminal Name (e.g., TECHCHIP): " NAME </dev/tty
read -p "Enter your Slogan (e.g., Your True Tech Navigator): " SLOGAN </dev/tty
read -p "Enter your Website (e.g., www.techchip.net): " WEBSITE </dev/tty

# Set default values if empty
NAME=${NAME:-"TECHCHIP"}
SLOGAN=${SLOGAN:-"Your True Tech Navigator"}
WEBSITE=${WEBSITE:-"www.techchip.net"}

# Check if tools are already installed and working
if ! command -v figlet &> /dev/null || ! command -v wget &> /dev/null; then
    echo -e "\n\e[1;33m[!] Required tools missing or broken. Installing/Repairing...\e[0m"
    if [ "$EUID" -ne 0 ]; then
        sudo apt-get update -y
        sudo apt-get install -y --fix-missing figlet wget
    else
        apt-get update -y
        apt-get install -y --fix-missing figlet wget
    fi
else
    echo -e "\n\e[1;32m[+] Required tools (figlet, wget) are already installed and working perfectly.\e[0m"
fi

echo -e "\e[1;32m[+] Downloading the blocky font...\e[0m"
mkdir -p ~/.local/share/figlet
wget -qO ~/.local/share/figlet/ANSI_Shadow.flf "https://raw.githubusercontent.com/xero/figlet-fonts/master/ANSI%20Shadow.flf"

echo -e "\e[1;32m[+] Generating custom text art...\e[0m"
TEXT_ART=$(figlet -d ~/.local/share/figlet -f ANSI_Shadow "$NAME")

MAX_LEN=0
while IFS= read -r line; do
    if (( ${#line} > MAX_LEN )); then MAX_LEN=${#line}; fi
done <<< "$TEXT_ART"

BOX_WIDTH=$(( MAX_LEN + 4 ))
TOP_BORDER="╔"
for (( i=0; i<BOX_WIDTH; i++ )); do TOP_BORDER="${TOP_BORDER}═"; done
TOP_BORDER="${TOP_BORDER}╗"

BOT_BORDER="╚"
for (( i=0; i<BOX_WIDTH; i++ )); do BOT_BORDER="${BOT_BORDER}═"; done
BOT_BORDER="${BOT_BORDER}╝"

BANNER_TXT="$HOME/.custom_banner_text.txt"
printf "\e[1;33m%s\e[0m\n" "$TOP_BORDER" > "$BANNER_TXT"

while IFS= read -r line; do
    pad_len=$(( MAX_LEN - ${#line} ))
    padding=""
    for (( i=0; i<pad_len; i++ )); do padding="${padding} "; done
    full_line="${line}${padding}"
    
    half=$(( MAX_LEN / 2 ))
    left_part="${full_line:0:$half}"
    right_part="${full_line:$half}"
    
    printf "\e[1;33m║\e[0m  \e[1;34m%s\e[1;31m%s\e[0m  \e[1;33m║\e[0m\n" "$left_part" "$right_part" >> "$BANNER_TXT"
done <<< "$TEXT_ART"

printf "\e[1;33m%s\e[0m\n" "$BOT_BORDER" >> "$BANNER_TXT"
printf "       \e[1;36m%s (%s)\e[0m\n\n" "$SLOGAN" "$WEBSITE" >> "$BANNER_TXT"

cat << 'EOF' > ~/.custom_banner.sh
#!/bin/bash
clear
cat ~/.custom_banner_text.txt
EOF
chmod +x ~/.custom_banner.sh

if [ -f ~/.zshrc ] && ! grep -q ".custom_banner.sh" ~/.zshrc; then
    echo "~/.custom_banner.sh" >> ~/.zshrc
fi
if [ -f ~/.bashrc ] && ! grep -q ".custom_banner.sh" ~/.bashrc; then
    echo "~/.custom_banner.sh" >> ~/.bashrc
fi

echo -e "\e[1;32m[+] Setup Complete! Your new banner is ready.\e[0m"
~/.custom_banner.sh
