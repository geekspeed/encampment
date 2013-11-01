HOME=~
mkdir -p $HOME/vms

if [ -z "$ENCAMPMENT_ROOT" ]; then
	ENCAMPMENT_ROOT="$HOME/code/encampment"
fi

ln -s $ENCAMPMENT_ROOT/tripit/dm $HOME/vms/dm
