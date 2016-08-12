#!/bin/bash
# Author: Mecu Sorin       Phone: 0040747020102
# Requests 3 pages from http://localhost:5000

while true; do

echo -e "\n\nPress q to quit"
read -rsn1 input
if [ "$input" == "q" ]; then
    break
fi
curl http://localhost:5000/1
curl http://localhost:5000/2
curl http://localhost:5000/3

done