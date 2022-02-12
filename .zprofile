if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo -e "\e[33mHomebrew (\e[36mhttps://brew.sh\e[33m) is not installed.\e[0m"
fi
