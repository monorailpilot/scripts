#Place in your bashrc/bashprofile to automatically ssh to remote hosts (IE just type the host name at a bash prompt to initiate ssh).

###Auto Login coolness
command_not_found_handle () {
    if [[ ! "$1" ]] ; then
        return 127
    fi

    if [[ "$2" ]] ; then
        echo "-bash: $1: command not found"
        return 127
    fi

    ssh $1 2>/dev/null
    if [ $? -eq 255 ] ; then
        echo "-bash: $1: command not found"
        return 127;
    fi
}
