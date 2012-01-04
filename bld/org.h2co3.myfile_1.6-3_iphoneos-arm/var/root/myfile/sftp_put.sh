#!/bin/bash

/usr/bin/sshpass -p "$2" sftp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "$1" << EOF
put "$3" "$4"
EOF
