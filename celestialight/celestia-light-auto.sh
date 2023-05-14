#!/bin/bash

# Check if .bash_profile exists
if [ ! -f ~/.bash_profile ]; then
    # If not, check if .profile exists
    if [ -f ~/.profile ]; then
        # If .profile exists, rename it to .bash_profile
        mv ~/.profile ~/.bash_profile
    else
        # If neither file exists, create .bash_profile
        touch ~/.bash_profile
    fi
fi

sudo apt update && sudo apt upgrade -y	

#install pre-reqs
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu -y

#install go ver1.20.1 sh
wget "https://raw.githubusercontent.com/GLCNI/celestia-node-scripts/main/multi-network/go/go-v1.20.3-install.sh"
chmod a+x go-v1.20.3-install.sh
./go-v1.20.3-install.sh

source ~/.bash_profile

# confirm install
if command -v go &> /dev/null; then
    echo "Go is installed and the PATH is set up correctly"
    go version
else
    echo "Go is not installed or the PATH is not set up correctly"
fi

#NETWORK SELECTION
NETWORK="blockspacerace" # Selecting blockspacerace automatically

#INSTALL CELESTIA NODE
#version based on network selection
cd $HOME
rm -rf celestia-node
git clone https://github.com/celestiaorg/celestia-node.git
cd celestia-node/

#select version tag based on network
if [ "$NETWORK" == "mocha" ]; then
    CELESTIA_VER="v0.6.4"
elif [ "$NETWORK" == "blockspacerace" ]; then
    CELESTIA_VER="v0.9.4"
elif [ "$NETWORK" == "arabica" ]; then
    CELESTIA_VER="v0.7.1"
fi

echo "export CELESTIA_VER=$CELESTIA_VER" >> $HOME/.bash_profile
source $HOME/.bash_profile

#checkout appropriate version and build Celestia
git checkout tags/$CELESTIA_VER
make build 
sudo make install				
make cel-key

#INITIALISE AS LIGHT NODE
celestia light init --p2p.network $NETWORK

#SETUP VARIABLES
source $HOME/.bash_profile

#select gRPC endpoint use default or enter custom
if [ "$NETWORK" == "mocha" ]; then
    RPC_ENDPOINT="https://rpc-mocha.pops.one"
    echo "export RPC_ENDPOINT=$RPC_ENDPOINT" >> $HOME/.bash_profile
fi

if [ "$NETWORK" == "blockspacerace" ]; then
    RPC_ENDPOINT="https://rpc-blockspacerace.pops.one"
    echo "export RPC_ENDPOINT=$RPC_ENDPOINT" >> $HOME/.bash_profile
fi

if [ "$NETWORK" == "arabica" ]; then
    RPC_ENDPOINT="https://limani.celestia-devops.dev"
    echo "export RPC_ENDPOINT=$RPC_ENDPOINT" >> $HOME/.bash_profile
fi

#WALLET SETUP
WALLET="my_celes_key" # Selecting auto-generated wallet automatically
echo "export WALLET=$WALLET" >> $HOME/.bash_profile

# Display wallet info or import existing
if [ "$WALLET" == "my_celes_key" ]; then
    ./cel-key list --node.type light --p2p.network $NETWORK --keyring-backend test
    echo "To pay for data transactions, this address must be funded. Press any key to continue."
    read -n 1 -r -s -p ""
else
    ./cel-key add $WALLET --keyring-backend test --node.type light --p2p.network $NETWORK --recover
fi

# Setup system service
sudo tee <<EOF >/dev/null /etc/systemd/system/celestia-light.service
[Unit]
Description=celestia-light Cosmos daemon
After=network-online.target

[Service]
User=$USER
ExecStart=$(which celestia) light start --keyring.accname $WALLET --p2p.network $NETWORK --core.ip $RPC_ENDPOINT --gateway --gateway.addr localhost --metrics --metrics.tls=false --metrics.endpoint 0.0.0.0:4318
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

# Start the service
sudo systemctl daemon-reload
sudo systemctl enable celestia-light
sudo systemctl start celestia-light

# Display logs
echo "Celestia light node is now setup and running."
echo "You can display logs at any time with 'journalctl -u celestia-light.service -f'."
echo -n "Press 'y' to display logs on the terminal (otherwise press Enter): "
read displaylogs
echo
if [ "$displaylogs" == "y" ]; then
    journalctl -u celestia-light.service -f
fi
