#!/bin/bash

##################################################################
# Title:     start-remote-support.sh
# Copyright (C) 2014 Neighborhood Guard, Inc. All rights reserved
# Author:    Jesper Jurcenoks, Neighborhood Guard
# Version:   1.0
#
# start-remote_support.sh is free software: you can redistribute it and/or
# modify it under the terms of the GNU Affero General Public
# License as published by # the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.
#
# start-remote-software.sh is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General
# Public License along with piguard-menu.
# If not, see <http://www.gnu.org/licenses/>.
#
##################################################################


echo "Kill any old tunnel so that we are connecting to the right port"
echo "and don't overload dreamhost with too many SSH connections as"
echo "dreamhost has a tendency to kill ssh sessions if they think"
echo " SSH sessions are taking too many CPU cycles"
#kill $(pgrep -f "ssh -fN -R")

HOSTNAME="`cat /etc/hostname`"
URL="http://support.neighborhoodguard.org/remote-support/"$HOSTNAME"-remote-support"
wget $URL -O ~/ftp_upload/remote-support
USERNAME=$(grep "^username.*=" ~/ftp_upload/remote-support | sed "s/username.*=//1" | sed "s/[^a-zA-Z0-9._-]//1")
HOSTNAME=$(grep "^host.*=" ~/ftp_upload/remote-support | sed "s/host.*=//1" | sed "s/[^a-zA-Z0-9._-]//1")
SUPPORTPORT=$(grep "^port.*=" ~/ftp_upload/remote-support | grep -o "[0-9]*" | sed "s/[^0-9]//1")

echo "username '"$USERNAME"'"
echo "hostname '"$HOSTNAME"'"
echo "port '"$SUPPORTPORT"'"

autossh -fN -i ~/.ssh/tunnel_rsa -R $SUPPORTPORT:localhost:22 $USERNAME@$HOSTNAME

