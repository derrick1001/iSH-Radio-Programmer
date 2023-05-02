#!/bin/sh

# Install openssh with apk add openssh
# Install busybox-extras with apk add busybox-extras

apk add openssh 
apk add busybox-extras
mv /etc/profile.d/color_prompt.sh.disabled /etc/profile.d/color_prompt.sh
source /etc/profile.d/color_prompt.sh
mv iSH-scripts/ash_alias.sh /etc/profile.d/
source /etc/profile.d/ash_alias.sh

