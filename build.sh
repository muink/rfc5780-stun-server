#!/bin/sh

hosts='https://github.com/pradt2/always-online-stun/raw/master/valid_hosts.txt'
hosts_tcp='https://github.com/pradt2/always-online-stun/raw/master/valid_hosts_tcp.txt'

#list <proto> <timeout> <url>
list() {
	for i in $(curl -L "$3"); do
		result="$(timeout $1 stunclient --mode full --localport 20388 --protocol $2 ${i//:/ } 2>/dev/null)"
		echo "$result" | grep -q 'Behavior test: success' && echo $i
	done
}

list 30 udp "$hosts" | sort > "valid_hosts_rfc5780.txt"
list 10 tcp "$hosts_tcp" | sort > "valid_hosts_rfc5780_tcp.txt"
