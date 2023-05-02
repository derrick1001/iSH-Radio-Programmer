#!/bin/sh

# Install openssh with apk add openssh
# Install busybox-extras with apk add busybox-extras

mv /etc/profile.d/color_prompt.sh.disabled /etc/profile.d/color_prompt.sh
source /etc/profile.d/color_prompt.sh
mv ash_alias.sh /etc/profile.d/
source /etc/profile.d/ash_alias.sh

