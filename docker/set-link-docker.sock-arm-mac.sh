#!/bin/bash

set -e


USER_NAME=${SUDO_USER:-$(whoami)}

# Docker socket file path (default location on ARM M-series MacOS)
SOURCE_SOCKET="/Users/$USER_NAME/.docker/run/docker.sock"
TARGET_SOCKET="/var/run/docker.sock"

# Check if the original Docker socket file exists
if [[ ! -S $SOURCE_SOCKET ]]; then
  echo "The original Docker socket file ($SOURCE_SOCKET) does not exist. Please ensure Docker Desktop is running. or the file path is correct."
  exit 1
fi

# Remove existing symbolic link or file
if [[ -e $TARGET_SOCKET ]]; then
  echo "Removing existing symbolic link or file ($TARGET_SOCKET)..."
  rm -f $TARGET_SOCKET
fi

# Create symbolic link
echo "Creating symbolic link: $TARGET_SOCKET -> $SOURCE_SOCKET"
ln -s $SOURCE_SOCKET $TARGET_SOCKET

# Check result
if [[ -L $TARGET_SOCKET ]]; then
  echo "Symbolic link has been successfully created!"
  ls -l $TARGET_SOCKET
else
  echo "Failed to create symbolic link."
  exit 1
fi