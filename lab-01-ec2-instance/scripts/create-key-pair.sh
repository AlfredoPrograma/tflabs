#!/bin/bash

# This script creates a key pair for SSH access

if [ -z "$1" ]; then
  path="$HOME/.ssh/tflabs"
else
  path="$1"
fi

echo "Creating key pair..."

ssh-keygen -t rsa -f "$path" -N ""

echo "Key part created at $path"