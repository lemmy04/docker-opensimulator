#!/bin/sh
### In opensim.sh (make sure this file is chmod +x):


cd /home/opensim/opensim/bin/
exec screen -S OpenSim -D -m mono ./OpenSim.exe
