FROM alpine

COPY smb-base.conf /etc/samba/
COPY functions.sh /etc/samba/functions.sh
COPY bashrc /root/.bashrc

RUN apk update
RUN apk add samba bash
RUN touch /etc/samba/firstrun
RUN mkdir /share


CMD bash
