#!/bin/sh
domain=${1:?usage: $0 mail.example.org}
shift

show() {
    printf "%s\n" "$*"
}
run() {
    show "+ $*"
    "$@"
}
get_certs() {
    run openssl s_client -CApath /etc/ssl/certs -connect "$domain":25 \
         -servername "$domain" -verify_hostname "$domain" -starttls smtp "$@" < /dev/null
}
certs=$(get_certs "$@")
show "$certs"
certinfo=$(printf "%s\n" "$certs" | openssl x509 -noout -text)
show "$certinfo"

