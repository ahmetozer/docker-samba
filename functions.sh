
function fastinstall() {
  passato=${passato:-yes}
  username=${username:-root}
  usernameforfastinstall=$username
  useradd
  username=$usernameforfastinstall
  sharename=${sharename:-root}
  sharecomment=${sharecomment:-root directory}
  sharepath=${sharepath:-/share/root}
  shareadd
  unset username
  unset passato
}

function useradd() {

  username=${username:-$1}
  password=${password:-$2}
  unset params[1]
  unset params[2]
  #Checking the username is true ?
  while [[ ! $username =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z0-9]+$|^[a-zA-Z0-9_.+-]+$ ]];
  do

    #if the username setted by the envoriment bypass to read username
    if [ -z "$username" ]
    then
      read -p 'username » ' -e  -i root username
    fi

    #Checking the username pattern
    if [[ ! $username =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z0-9]+$|^[a-zA-Z0-9_.+-]+$ ]];
    then
        echo 'Your username is has a unexpected char. You can write a email adress or username'
        username=''
    fi
  done

  passrandom=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c8`

  if [ ! -z "$password" ]
  then
    password1="$password"
    password2="$password"
  else
    if [ "$passato" == "yes" ]
    then
      password="$passrandom"
      echo "Your password is $password"
      password1="$password"
      password2="$password"
    fi
  fi

  passpattern="^[0-9A-z#$%^&*()\-_+={}[\]|\:;\"'<>,.?]{8,}$"
  while [[ ! "$password1" == "$password2" ]] || [ -z "$password1" ] || [[ ! $password1 =~ $passpattern ]];
  do
      #Checking the pattern of password
      while [[ ! $password1 =~ $passpattern ]];
      do
        #if the setted by envoriment bypass to asking password
        if [ -z "$password1" ]
        then
          read -p "Please enter password (at least 8 character) random password $passrandom »" -s password1
          echo
        fi

        #Checking pattern of password
        if [[ ! $password1 =~ $passpattern ]]
        then
          echo 'Your password is contains unexpected char or does not have requirements'
          password1=''
          password2=''
        fi

      done

      if [ -z "$password2" ]
      then
        read -p 'Please retype password » ' -s password2
        echo
      fi

      if [[ ! $password1 == $password2 ]]
      then
        echo 'Your passwords do not match each other'
        password1=''
        password2=''
      fi
  done

  #Adding new samba user
  adduser --disabled-password $username > /dev/null 2>&1
  echo "$password1
$password2" | smbpasswd -a $username

  usernameforshare=$username
  unset password1
  unset password2
  unset username
  unset password
  [ ! -f "/etc/samba/firstrun" ] && reload-samba

}

function shareadd() {

    if [ ! -z $1 ]
    then
      sharename=${sharename:-$1}
      sharepath=${sharepath:-$2}
      username=${username:-$3}
      sharecomment=${sharecomment:-$4}
    fi
    #To getting Share Name From User
    while [[ ! $sharename =~ ^[a-zA-Z0-9._+-]+$ ]];
    do
      #if the username setted by the envoriment bypass to read username
      if [ -z "$sharename" ]
      then
        read -p 'Share Name » ' -e  -i root sharename
      fi

      #Checking the username pattern
      if [[ $sharename =~ ^[a-zA-Z0-9._+-]+$ ]];
      then
        if [ -f "/etc/samba/conf.d/$sharename.conf" ];
        then
          echo "Your server configration allready located at /etc/samba/conf.d/$sharefile.conf"
          echo 'Please remove this config or use a different-name'
          sharename=''
        fi
      else
          echo 'Your Share Name has a unexpected char. You can use A-z 0-9 and _- characters'
          sharename=''
      fi
    done

    #To getting Share Comment From User
    while [[ ! $sharecomment =~ (^[ a-zA-Z0-9\.\-_]+)$ ]];
    do
      #if the username setted by the envoriment bypass to read username
      if [ -z "$sharecomment" ]
      then
        read -p 'Share Comment » ' -e  -i "$sharename Directory" sharecomment
      fi

      #Checking the username pattern
      if [[ ! $sharecomment =~ (^[ a-zA-Z0-9\.\-_]+)$ ]];
      then
          echo 'Your Share comment has a unexpected char. You can use A-z 0-9 and _- characters'
          sharecomment=''
      fi
    done

    #To getting Share Path From User
    while [[ ! $sharepath =~ (^[/a-zA-Z0-9._+-]+)$ ]];
    do
      #if the username setted by the envoriment bypass to read username
      if [ -z "$sharepath" ]
      then
        read -p 'Share path » ' -e  -i "/share/$sharename" sharepath
      fi

      #Checking the username pattern
      if [[ ! $sharepath =~ (^[/a-zA-Z0-9._+-]+)$ ]];
      then
          echo 'Your Share path has a unexpected char. You can use A-z 0-9 and _- characters'
          sharepath=''
      fi
    done

    #To getting UserName From User for allowed users
    while [[ ! $username =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z0-9]+$|^[a-zA-Z0-9_.+-]+$ ]];
    do

      #if the username setted by the envoriment bypass to read username
      if [ -z "$usernameforshare" ]
      then
        read -p "Valid users for $sharename » " username
      else
        if [ -z "$username" ]
        then
          read -p "Valid users for $sharename » " -e  -i $usernameforshare username
        fi
      fi

      #Checking the username pattern
      if [[ ! $username =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z0-9]+$|^[a-zA-Z0-9_.+-]+$ ]];
      then
          echo 'Your username is has a unexpected char. You can write a email adresss or usernames'
          username=''
      fi
    done


    #Writing share configration
    if [[ $sharename =~ ^[a-zA-Z0-9._+-]+$ ]] && [ ! -z "$sharename" ] && [ ! -z "$username" ] && [ ! -z "$sharecomment" ];
    then
      mkdir -p $sharepath
      echo "Share name » $sharename
share dir » $sharepath
share comment » $sharecomment
share valid users » $username"
      echo "[$sharename]
              comment = $sharecomment
              path = $sharepath
              read only = No
              writeable = yes
              browsable = yes
              valid users = $username
              public = no
              create mask = 0640
              directory mask = 0750
              guest ok = no" > /etc/samba/conf.d/$sharename.conf
      update-samba
    else
      echo "Error. Your configration file cannot saved"
    fi

    unset sharename
    unset sharecomment
    unset sharepath
    unset username
    unset usernameforshare
}



function sharedel() {
    sharename=${sharename:-$1}
    #Checking file is exist end does not have a dangerous character like a "*"
    if [ -f "/etc/samba/conf.d/$sharename.conf" ] && [[ $sharename =~ ^[a-zA-Z0-9._+-]+$ ]] ;
    then
      echo "Deleting file /etc/samba/conf.d/$sharename.conf"
      rm /etc/samba/conf.d/$sharename.conf
      update-samba
    else
      echo "$sharename is not exist in config location"
    fi
}

function sharelist() {
  ls -1 /etc/samba/conf.d/ | sed -e 's/\.conf$//'
}

function shareshow() {
  if [ -f "/etc/samba/conf.d/$1.conf" ] && [[ $1 =~ ^[a-zA-Z0-9._+-]+$ ]] ;
  then
    cat /etc/samba/conf.d/$1.conf
  else
    echo "This config not exist"
  fi
}

function update-samba() {
  echo "Re generating config file"
  cat /etc/samba/smb-base.conf > /etc/samba/smb.conf
  cat /etc/samba/conf.d/*.conf >> /etc/samba/smb.conf
  reload-samba
}

function reload-samba() {
  echo "Reloading samba service"
  smbcontrol all reload-config
}
