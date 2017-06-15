OPS_ACC=ops.tim.lindeberg
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function sshops() {
	trap cleanup EXIT
	if ! command -v $PROGRAM >/dev/null 2>&1; then
		echo "sshops requires sshpass. Install it using a package manager e.g. 'brew install sshpass'."
		exit 1
	fi

	SERVER=$1
	read -s -p "Password: " PASSWORD
	
	python ./sshops.py $SERVER $PASSWORD

	echo $PASSWORD > tmp.txt

	sshpass -f tmp.txt ssh "$OPS_ACC@$SERVER"
  	cleanup
}

function cleanup() {
	rm tmp.txt > /dev/null 2>&1
}

sshops midgard-stage