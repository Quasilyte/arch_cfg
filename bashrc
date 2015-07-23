#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# User-defined below:

export PATH="/home/quasilyte/.cask/bin:$PATH"

kbdli-set() {
    if [ $1 -gt 100 ]; then
	level=100
    elif [ $1 -lt 0 ]; then
	level=0
    else
	level=$1
    fi
    
    echo $level | sudo tee /sys/class/leds/smc\:\:kbd_backlight/brightness > /dev/null
    echo "keyboard backlight brightness set to $level%"
}

kbdli-get() {
    level=$(cat /sys/class/leds/smc\:\:kbd_backlight/brightness)
    
    echo "$level"
}

kbdli-add() {
    kbdli-set $(($(kbdli-get)+10))
}

kbdli-sub() {
    kbdli-set $(($(kbdli-get)-10))
}

monli-set() {
    if [ $1 -gt 100 ]; then
	echo 'brightness can not be higher than 100%'
    elif [ $1 -lt 10 ]; then
	echo 'it is forbidden to set monitor brightness lower than 10%'
    else
	echo $(($1*10/4)) | sudo tee /sys/class/backlight/mba6x_backlight/brightness > /dev/null
	echo "monitor brightness set to $1%"
    fi	
}

monli-get() {
    level=$(cat /sys/class/backlight/mba6x_backlight/brightness)
    
    echo "$((level/10*4))"
}

monli-add() {
    monli-set $(($(monli-get)+10))
}

monli-sub() {
    monli-set $(($(monli-get)-10))
}
