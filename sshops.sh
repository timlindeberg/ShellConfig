OPS_ACC=ops.tim.lindeberg
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function cleanup() {
	rm tmp.txt > /dev/null 2>&1
}

trap cleanup EXIT
if ! command -v $PROGRAM >/dev/null 2>&1; then
	echo "sshops requires sshpass. Install it using a package manager e.g. 'brew install sshpass'."
	exit 1
fi

SERVER=$1

if [ -z "$SERVER" ]; then
	echo "usage: sshops <server>"
	exit 1
fi

MAX_TRIES=5
TRIES=0
while [ $TRIES -le $MAX_TRIES ]; do
	read -s -p "Password:" PASSWORD
	echo
	echo $PASSWORD > tmp.txt

	python3 /Users/timlin/git/ShellConfigDeployment/scd.py -f tmp.txt $SERVER
	if [ "$?" -eq '5' ]; then
		let TRIES=TRIES+1 
		continue
	fi

	sshpass -f tmp.txt ssh "$OPS_ACC@$SERVER" -t zsh
	if [ "$?" -eq '5' ]; then
		let TRIES=TRIES+1 
		continue
	fi
	break
done

cleanup
