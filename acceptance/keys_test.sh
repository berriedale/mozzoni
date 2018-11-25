#!/usr/bin/env bash

HOSTNAME=localhost
PORT=6379
CONNECT_TIMEOUT=5

function send_buffer {
    echo -e "${1}" | nc -w ${CONNECT_TIMEOUT} \
                        -N ${HOSTNAME} ${PORT}
}

testSet() {
    output=$(send_buffer '*3\r\n$3\r\nSET\r\n$8\r\ncachekey\r\n$4\r\nfake\r\n')
    assertContains "${output}" "+OK"
}

testGet() {
    send_buffer '*3\r\n$3\r\nSET\r\n$8\r\ncachekey\r\n$8\r\nzoomzoom\r\n' > /dev/null
    output=$(send_buffer '*2\r\n$3\r\nGET\r\n$8\r\ncachekey\r\n')
    assertContains "${output}" "zoomzoom"
}

source ./contrib/shunit2/shunit2
