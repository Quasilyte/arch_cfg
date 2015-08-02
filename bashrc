#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# User-defined below:

alias tar="tar -xvf "
alias g++="g++ -std=c++11 -pedantic -Wall -Wextra -Wcast-align -Wcast-qual -Wformat=2 -Winit-self -Wlogical-op -Wmissing-declarations -Wmissing-include-dirs -Wnoexcept -Wold-style-cast -Woverloaded-virtual -Wredundant-decls -Wshadow -Wsign-conversion -Wsign-promo -Wstrict-null-sentinel -Wstrict-overflow=5 -Wswitch-default -Wundef -Werror -Wno-unused "

export PATH="/home/quasilyte/.cask/bin:$PATH"

declare -A wifi_profiles=(
    [home]=wlp3s0-WiFi-DOM.ru-6318
    [itpark]=wlp3s0-itpark-free-10mbit
)

wifi-start() {
    if [[ ${wifi_profiles[$1]} ]]; then
	netctl start ${wifi_profiles[$1]}
    else
	echo "invalid wifi profile given"
    fi
}
