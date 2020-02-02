#!/bin/sh
clear
  #if the password pre set by the envoriment

  if [ ! -z "$passato" ]
  then
    password=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-8}`
    echo "Your password is $password"
  fi
  if [ ! -z "$password" ]
  then
    password1="$password"
    password2="$password"
  fi

  passpattern="^[0-9A-z#$%^&*()\-_+={}[\]|\:;\"'<>,.?]{8,}$"
  while [[ ! "$password1" == "$password2" ]] || [ -z "$password1" ];
  do
      #Checking the pattern of password
      while [[ ! $password1 =~ $passpattern ]];
      do
        #if the setted by envoriment bypass to asking password
        if [ -z "$password1" ]
        then
          read -p 'Please enter password (at least 8 character)»' -s password1
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
