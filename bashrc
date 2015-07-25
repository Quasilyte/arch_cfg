#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# User-defined below:

export PATH="/home/quasilyte/.cask/bin:$PATH"

declare -A wifi_profiles=(
    [home]=wlp3s0-WiFi-DOM.ru-6318
    [itpark]=wlp3s0-itpark-free-10mbit
)

wifi-start() {
    if [ ${wifi_profiles[$1]} ]; then
	netctl start ${wifi_profiles[$1]}
    else
	echo "invalid wifi profile given"
    fi
}
