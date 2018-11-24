#!/usr/bin/env bash

HOSTNAME=localhost
PORT=6379

which nc > /dev/null

if [ $? -ne 0 ]; then
    echo ">> netcat is required to run this script"
    exit 1;
fi;

function send_buffer {
    output=$( echo -e ${1} | nc -v -w 5 -N ${HOSTNAME} ${PORT} 2>&1 )
    echo ${output} | grep ${2} 2>&1 > /dev/null

    if [ $? -eq 0 ]; then
        ok ".. success"
    else
        err "..failed"
        echo -e ${output}
    fi;
}

function ok {
    echo -e "\033[1;32m${@}\033[0m"
}

function err {
    echo -e "\033[1;31m${@}\033[0m"
}

echo -n "Sending PING.. "
send_buffer '*1\r\n$4\r\nPING\r\n' '+PONG'
echo -n "Sending PING (human readable).. "
send_buffer 'PING\r\n' "+PONG"
echo


echo -n "Sending SET.. "
send_buffer '*3\r\n$3\r\nSET\r\n$8\r\ncachekey\r\n$4\r\nfake\r\n' "+OK"


#echo -n "Simple string.. "
#send_buffer "+OK\r\n"
#echo ".. ok"
#
#echo -n "Error.. "
#send_buffer "-ERR Unknown failure occurred\r\n"
#echo ".. ok"
#
#echo -n "Integer.. "
#send_buffer ":1337\r\n"
#echo ".. ok"
#
#echo -n "Bulk string.. "
#send_buffer "\$5\r\nHELLO"
#echo ".. ok"
