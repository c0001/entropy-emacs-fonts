#!/bin/sh

error_quit ()
{
    echo -e "\e[31mSome thing went wrong ($1), Abort\e[0m"
    exit 1
}

[ -z "$HOME" ] && error_quit "No HOME env detected"

! command -v cp 1>/dev/null 2>&1 && error_quit "\
command not found: cp"
! command -v install 1>/dev/null 2>&1 && error_quit "\
command not found: install"

fc_host="${HOME}"/.local/share/fonts
if [ ! -e "$fc_host" ]
then
    mkdir -p "$fc_host"
    [ ! $? -eq 0 ] && error_quit "mkdir fatal"
fi

fc_command=fc-cache

fc_command_p=0

command -v $fc_command 1>/dev/null 2>&1 && fc_command_p=1

set -e
if [ $fc_command_p -eq 1 ]
then
    for dir in $(ls -A Fonts)
    do
        echo "\e[32mInstall\e[0m [FONT: $dir] to [Target: $fc_host] ..."
        install -d "${fc_host}/${dir}"
        cp -a "Fonts/${dir}"/* "${fc_host}/${dir}/"
        echo "\e[32mDone\e[0m"
    done

    cd "$fc_host"
    echo "\e[32mDoing\e[0m $fc_command -f -v ..."
    $fc_command -f
else
    echo "\e[33mNot support auto install font in current system, \
please manually install font under <$(pwd)> .\e0m"
fi

exit 0
