#!/usr/bin/env bash

HOSTNAME=localhost
PORT=6379

which nc > /dev/null

if [ $? -ne 0 ]; then
    echo ">> netcat is required to run this script"
    exit 1;
fi;

set -xe

function send_buffer {
    echo -e ${1} | nc -q 1 ${HOSTNAME} ${PORT}
}

function ok {
    echo -e "\033[1;32m${@}\033[0m"
}

function err {
    echo -e "\033[1;31m${@}\033[0m"
}

echo -n "Sending PING.. "
send_buffer '*1\r\n$4\r\nPING\r\n' | grep "+PONG"

if [ $? -eq 0 ]; then
    ok ".. success"
else
    err "..failed"
fi;


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
