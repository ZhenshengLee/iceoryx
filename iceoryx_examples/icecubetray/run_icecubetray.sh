#!/bin/bash

WORKSPACE=$(git rev-parse --show-toplevel)

# Create groups
sudo groupadd -f privileged
sudo groupadd -f unprivileged
sudo groupadd -f iceoryx

# Create users w/o homedir
sudo useradd -M perception
sudo useradd -M infotainment
sudo useradd -M roudi
sudo useradd -M notallowed

# Assign users to group and disable login
sudo usermod -L perception -a -G privileged
sudo usermod -L infotainment -a -G unprivileged
sudo usermod -L perception -a -G iceoryx
sudo usermod -L infotainment -a -G iceoryx
sudo usermod -L roudi -a -G iceoryx
sudo usermod -L notallowed -a -G iceoryx

# If you're using e.g Yocto or QNX refer to the manual on how to set up groups, users and permissions


# Allow RouDi to send SIGKILL to other apps
sudo setcap cap_kill=ep ./build/iceoryx_examples/icecubetray/iox-cpp-roudi-static-segments

# Start custom RouDi in 'iceoryx' group
sudo -u roudi -g iceoryx -- $WORKSPACE/build/iceoryx_examples/icecubetray/iox-cpp-roudi-static-segments

# Start perception app as 'perception' user
sudo -u perception -g iceoryx -- $WORKSPACE/build/iceoryx_examples/icecubetray/iox-cpp-radar

# Start display app as 'infotainment' user
sudo -u infotainment -g iceoryx -- $WORKSPACE/build/iceoryx_examples/icecubetray/iox-cpp-display
