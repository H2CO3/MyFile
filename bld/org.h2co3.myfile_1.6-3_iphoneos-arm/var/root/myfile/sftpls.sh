#!/bin/bash

/var/root/myfile/sftp_ls.sh "$1" "$2" "$3" 2>/var/root/myfile/sftpls.err.log | tail -n +2 >/var/root/myfile/sftpls.txt
