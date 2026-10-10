#!/bin/sh

hosts='https://github.com/pradt2/always-online-stun/raw/master/valid_hosts.txt'
hosts_tcp='https://github.com/pradt2/always-online-stun/raw/master/valid_hosts_tcp.txt'

#list <timeout> <proto> <url>
list() {
	for i in $(curl -L "$3"); do
		result="$(timeout $1 stunclient --mode full --localport 20388 --protocol $2 ${i//:/ } 2>/dev/null)"
		grep -q 'Behavior test: success' <<< "$result" && echo $i
	done
}

#ipv6list <listfile>
ipv6list() {
	for i in $(cat $1); do
		if [ -n "$(dig +short ${i%%:*} AAAA 2>/dev/null)" ]; then
			echo $i
		fi
	done
}

list 30 udp "$hosts" | sort | tee "valid_hosts_rfc5780.txt"
list 10 tcp "$hosts_tcp" | sort | tee "valid_hosts_rfc5780_tcp.txt"

ipv6list "valid_hosts_rfc5780.txt" | tee "valid_hosts_rfc5780_ipv6.txt"
ipv6list "valid_hosts_rfc5780_tcp.txt" | tee "valid_hosts_rfc5780_tcp_ipv6.txt"
