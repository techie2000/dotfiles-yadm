#!/bin/sh
# Based on http://mikaela.info/english/2015/02/24/znc160-ssl.html
if [ -z "$1" ]; then
    echo "Usage: $0 servername:port [-servername example.org]" 1>&2
    exit 1
fi
output=$(openssl s_client -showcerts -CApath /etc/ssl/certs -connect "$@" < /dev/null)
##echo "$output"
##echo "$output" | openssl x509 -md5 -fingerprint -noout
##echo "$output" | openssl x509 -sha1 -fingerprint -noout
echo "$output" | openssl x509 -sha256 -fingerprint -noout

