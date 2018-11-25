#!/usr/bin/env bash

HOSTNAME=localhost
PORT=6379
CONNECT_TIMEOUT=5

function send_buffer {
    echo -e "${1}" | nc -w ${CONNECT_TIMEOUT} \
                        -N ${HOSTNAME} ${PORT}
}

testPing() {
    output=$(send_buffer '*1\r\n$4\r\nPING\r\n')
    assertContains "${output}" "+PONG"
}

testSimplePing() {
    output=$(send_buffer 'PING\r\n')
    assertContains "${output}" "+PONG"
}

source ./contrib/shunit2/shunit2
