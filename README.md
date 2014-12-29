#wait-for-remote-support#

### Summary ###

Start Reverse SSH Tunnel for remote support after retrieving connection information from Neighborhoodguard support web.

Problem: You (the Supporter) are behind a firewall and have linux computers behind other firewalls that you need SSH access to (the Supportee)<br>
Solution: Have the Supportee connect with a reverse SSH tunnel to an SSH server on the internet  (Bouncing-server) and then you can connect to the same Bouncing-server and issue a command to get an ssh connection to the Suportee

Problem: You (the Supporter) does not want to have hardcoded Bouncing-server hostname, port etc lying on the Supportees, it is also a support nightmare<br>
Solution: Create a script to retrieve the information from a designated server.

###Easy Installation###

In Piguard Menu select "Support Menu" then "Install Remote Support"

###Manual Installation###

Download wait-for-remote-support.sh to ~/[your dir]

sudo wget https://raw.githubusercontent.com/JesperJurcenoks/wait-for-remote-support/master/wait-for-remote.support.sh -O ~/[your dir]/wait-for-remote-support.sh

Give wait-for-remote-support.sh execute rights 

sudo chmod +x ~/[your dir]/wait-for-remote-support.sh

To run on the host that needs remote support

~/[your dir]/wait-for-remote-support.sh

###Setup Connection without password prompt###
```
  HOSTNAME="`cat /etc/hostname`"
  URL="http://[your server here]/remote-support/"$HOSTNAME"-remote-support"
  wget $URL -O ~/[your dir]/remote-support
  if [ $? = 0 ]; then
    USERNAME=$(grep "^username.*=" ~/[your dir]/remote-support | sed "s/username.*=//1" | sed "s/[^a-zA-Z0-9._-]//1")
    HOSTNAME=$(grep "^host.*=" ~/[your dir]/remote-support | sed "s/host.*=//1" | sed "s/[^a-zA-Z0-9._-]//1")

    if [ -d "/home/pi/.ssh" ]; then
      echo "directory /home/pi/.ssh already exists"
    else
      mkdir ~/.ssh
      chmod 700 ~/.ssh
    fi
    if [ -e "/home/pi/.ssh/id_rsa" ]; then
      echo "RSA Key already exists - leave be"
    else
      ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ""
    fi
    echo "clear out the old bounce-server key"
    ssh-keygen -R $HOSTNAME
    echo "get the current bounce-server key"
    ssh-keyscan -H $HOSTNAME >> ~/.ssh/known_hosts
    echo "copy our key to bounce-server - Password required"
    ssh-copy-id $USERNAME@$HOSTNAME
  else
    echo "failed to get needed file"
    echo "try again"
    echo
    echo "press any key to continue"
    read -s -n 1
  fi
```


###Configuration of connection information###

Adapt the hardcoded server path to your own server name and path

place a file with connection information for each host where you are offering remote support, make sure each host has a unique name.

==========file contents============
```
username=[username on the bouncing ssh host]
host=[dnsname/IP address of the ssh host where you are bouncing the ssh connection through]
port=[unique port for each host]
remoteusername=[name used to login on the host that needs support]
```
===========end of file=============

Note: The script supports both Unix AND Windows style newlines in this file

###License###

piguard_check is open-source software available under the terms of the Affero GPL 3.0 license.  If the Affero GPL license does not meet your needs, other licensing arrangements are available from Neighborhood Guard, Inc.

###Contact Information###
If you have questions about this software, please contact:

Douglas Kerr, dougk at halekerr dot com, Board member for Software

or, 

Jesper Jurcennoks, jesper at jurcenoks dot com, President, Neighborhood Guard
