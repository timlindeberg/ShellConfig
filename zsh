DEFAULT_USER="ops.tim.lindeberg"

function chef-log() {
	less /var/log/chef/client.log
}

function rhversion() {
	cat /etc/redhat-release
}

function subl() {
	sudo /usr/local/bin/rmate -f "$@"
}
#!/bin/bash

# print_image filename inline base64contents
#   filename: Filename to convey to client
#   inline: 0 or 1
#   base64contents: Base64-encoded contents
function __print_image() {
    printf '\033]1337;File='
    if [[ -n "$1" ]]; then
      printf 'name='`echo -n "$1" | base64`";"
    fi
    if $(base64 --version | grep GNU > /dev/null)
    then
      BASE64ARG=-d
    else
      BASE64ARG=-D
    fi
    echo -n "$3" | base64 $BASE64ARG | wc -c | awk '{printf "size=%d",$1}'
    printf ";inline=$2"
    printf ":"
    echo -n "$3"
    printf '\a\n'
}

function imgcat() {
	if [ ! -t 0 ]; then
	  __print_image "" 1 "$(cat | base64)"
	  exit 0
	fi

	if [ $# -eq 0 ]; then
	  echo "Usage: imgcat filename ..."
	  echo "   or: cat filename | imgcat"
	  exit 1
	fi

	for fn in "$@"
	do
	  if [ -r "$fn" ] ; then
	    __print_image "$fn" 1 "$(base64 < "$fn" | tr -d \\r\\n)"
	  else
	    echo "imgcat: $fn: No such file or directory"
	    exit 1
	  fi
	done
}
