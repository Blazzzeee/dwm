#!/bin/bash

# Start NetworkManager service if not already running
if ! systemctl is-active --quiet NetworkManager.service; then
    echo "Starting NetworkManager..."
    sudo systemctl start NetworkManager.service
fi

# Start X server
echo "Starting graphical session..."
startx

