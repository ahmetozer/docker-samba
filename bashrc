#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PAGER=less
export PS1='\h:\w\$ '
umask 022

for script in /etc/profile.d/*.sh ; do
        if [ -r $script ] ; then
                . $script
        fi
done
source /etc/samba/functions.sh
if [ -f "/etc/samba/firstrun" ]; then
  mkdir -p /etc/samba/conf.d/
  if [ -z "$sharename" ]
  then
    echo 'Hello. You are installing samba server'
    useradd
    rm /etc/samba/firstrun
    shareadd
  else
    fastinstall
  fi

fi

ps=$(ps)
echo $ps | grep smbd > /dev/null  || smbd
echo $ps | grep nmbd > /dev/null  || nmbd
