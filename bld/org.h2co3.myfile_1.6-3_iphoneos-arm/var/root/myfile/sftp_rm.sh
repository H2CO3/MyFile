#!/bin/bash
/usr/bin/sshpass -p "$2" sftp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "$1" << EOF
rm "$3"
rmdir "$3"
EOF
