#!/bin/sh
usage="usage: $0 www.example.org[:port] [openssl args]"
domain=${1:?$usage}
shift

case $domain in
    --help)
        echo "$usage"
        exit
        ;;
    *:*)
        domain_and_port=$domain
        domain=${domain%:*}
        ;;
    *)
        domain_and_port=$domain:443
        ;;
esac

show() {
    printf '%s\n' "$*"
}
run() {
    show "+ $*"
    "$@"
}
get_certs() {
    run openssl s_client -CApath /etc/ssl/certs -connect "$domain_and_port" \
         -servername "$domain" -verify_hostname "$domain" "$@" < /dev/null
}
certs=$(get_certs "$@")
show "$certs"
certinfo=$(printf '%s\n' "$certs" | openssl x509 -noout -text)
show "$certinfo"

