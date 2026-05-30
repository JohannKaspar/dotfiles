#!/bin/zsh

# This script is used to tunnel ssh connections for jupyter notebooks
NODE_NAME=$1

if [ -z $NODE_NAME ]; then
    echo "Usage: tunnel_jupyter.sh <node_name>"
    return 1
fi

# kill any existing ssh tunnels on port 8888
lsof -ti:8888 | xargs kill

ssh -N -f -L 127.0.0.1:8888:localhost:8888 ${NODE_NAME}
