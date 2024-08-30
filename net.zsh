function in_subnet() {
    local ip ip_a mask netmask sub sub_ip rval start end
    local readonly BITMASK=0xFFFFFFFF

    # Read arguments.
    IFS=/ read sub mask <<< "${1}"
    IFS=. read -A sub_ip <<< "${sub}"
    IFS=. read -A ip_a <<< "${2}"

    # Calculate netmask.
    netmask=$(($BITMASK<<$((32-$mask)) & $BITMASK))

    # Determine address range.
    start=0
    for o in "${sub_ip[@]}"
    do
        start=$(($start<<8 | $o))
    done

    start=$(($start & $netmask))
    end=$(($start | ~$netmask & $BITMASK))

    # Convert IP address to 32-bit number.
    ip=0
    for o in "${ip_a[@]}"
    do
        ip=$(($ip<<8 | $o))
    done

    # Determine if IP in range.
    (( $ip >= $start )) && (( $ip <= $end )) && rval=1 || rval=0

    (( $DEBUG )) &&
        printf "ip=0x%08X; start=0x%08X; end=0x%08X; in_subnet=%u\n" $ip $start $end $rval 1>&2

    return "${rval}"
}

function grep_subnet() {
    if [ "$#" -ne 2 ]; then
        echo "Usage: grep_subnet <file with subnets> <file with IP addresses>"
        exit 1
    fi

    if [ ! -f "$1" ] || [ ! -f "$2" ]; then
        echo "File(s) does not exist!"
    fi

    for ip in $(cat "$2"); do
        local count=0
        for sub in $(cat "$1"); do
            in_subnet $sub $ip
            if [ "$?" -eq 1 ]; then
                echo "$ip is in $sub"
                ((count++))
            fi
        done
        if [ "$count" -eq 0 ]; then
            echo "$ip is in NO subnet"
        fi
    done
}
