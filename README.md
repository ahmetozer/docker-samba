# Samba for Docker Containers

Easy to use samba file share server for docker containers.

## Getting Container Image
For the installation you can use docker pull command to get samba container
```bash
docker pull ahmetozer/samba
```

If you want to build in your computer you can use git and docker build
```bash
git clone git@github.com:AhmetOZER/docker-samba.git
cd docker-samba
docker build -t samba .
```

## Basic Run
It is easy to use and configure with automated script.

```bash
docker run --it samba
 ```

## Share Folders With Samba Container
If you want to share outside of folder you can use -v argumant while creating docker.
-v has a ":" to bind local and container folder. Before the ":" it's your server directory, after the ":" it's your container directory
For example your website files at /var/www directory and you want to share your web folder with samba
```bash
docker run -it -v/var/www:/share/web samba

```



## Container Commands
 This script also has a some basic futures.

### Add User
```bash
useradd   
```
### Add Share
```bash
shareadd  
```

### List Shares
```bash
sharelist
```

### Show Configure of Share
```bash
shareshow sharename
```
### Update Samba Configuration
```bash
update-samba
```
### Delete Share
```bash
sharedel sharename   
```

### Reload Samba
```bash
reload-samba
 ```
