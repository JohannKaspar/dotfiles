#!/bin/zsh

# Script for tunneling ssh connections for tensorboard
NODE_NAME=$1
OUT_PORT=$2

ssh -N -f -L 127.0.0.1:${OUT_PORT:-6007}:localhost:6006 ${NODE_NAME}
