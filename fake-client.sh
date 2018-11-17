#!/usr/bin/env bash

HOSTNAME=localhost
PORT=6379

which nc > /dev/null

if [ $? -ne 0 ]; then
    echo ">> netcat is required to run this script"
    exit 1;
fi;

function send_buffer {
    echo -e ${1} | nc -q 1 ${HOSTNAME} ${PORT}
}

echo -n "Simple string.. "
send_buffer "+OK\r\n"
echo ".. ok"

echo -n "Error.. "
send_buffer "-ERR Unknown failure occurred\r\n"
echo ".. ok"

echo -n "Integer.. "
send_buffer ":1337\r\n"
echo ".. ok"
