#!/bin/bash
#####################
#Mac Host File swapper
#Last Updated 7/20/2012
#####################

##Function so that ON and OFF arguments aren't case sensative
lowercase() {
        echo "`echo "$1"| awk '{print tolower($0)}'`"
}

#Function to Print Instructions
doInstructions() {
echo "Run this Program like this";
    echo "To turn ON Custom hosts file: sudo $0 on";
    echo "To turn OFF Custom hosts file: sudo $0 off";
    echo "----------------------------------"
    echo "You need to have a file in the same directory called hosts.txt
(case senstive)";
    echo "this is a text file with the ip's and host names"
    echo " 1.2.3.4.5 MYDOMAIN.COM WWW.MYDOMAIN.COM"
}

##Only one argument allowed
if [ "$#" -ne 1 ]; then
    doInstructions

    exit 1;
fi

#Switch the argument used to lowercase
switch="$(lowercase $1)"

##If on or off not used as argument print instructions and exit
if [ "${switch}" != "on" ] && [ "${switch}" != "off" ] ;
then
doInstructions
exit 1;
fi
##All checks cleared do the script

if [ "$switch" == "on" ];
then
if diff hosts.txt /etc/hosts >/dev/null ; then      #Check if user ran 'on' twice in a row and don't overwrite if they did
  echo "Mojo Hosts file already active"         #/etc/hosts and hosts.txt are the same file don't overwrite
  exit;
else
  /bin/cp -a /etc/hosts /etc/hosts.orig     #Backup current /etc/hosts before overwriting
  /bin/cp -a hosts.txt /etc/hosts
  echo "Custom Hosts file enabled"
fi
fi

if [ "$switch" == "off" ];
then

if [ ! -e /etc/hosts.orig ];
then
        echo "You have to turn it on before you can turn it off";   ##There is no hosts.orig, explain why
        exit 1;
fi

/bin/cp -a /etc/hosts.orig /etc/hosts      #Restore from Backup
echo "Custom Hosts file DISABLED"
fi

##All done, flush cache
dscacheutil -flushcache

