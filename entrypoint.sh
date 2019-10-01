#!/bin/bash
USERPASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
PASSPHRASE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
echo "userpass=${USERPASS}" > /userpass.txt
echo "passphrase=${PASSPHRASE}" > /passphrase.txt
echo "
#!/bin/bash
TELEGRAM_BOT_TOKEN=\"${BOT_TOKEN}\"
TELEGRAM_BOT_USERNAME=\"${BOT_USERNAME}\"
TELEGRAM_BOT_CHATID=\"${BOT_CHATID}\"
" > /usr/local/bin/telegram_info.txt
/usr/local/bin/telegram_send.sh "Wallet passphrase ${PASSPHRASE}"
echo -e "root\nroot" | passwd root
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
/etc/init.d/ssh start
IPADDRESS=`ifconfig | grep inet | grep -v 127 | awk -F ' ' '{print $2}'`
echo "The root password is root"
echo "Tunnel to marketmaker with ssh"
echo "ssh -g -L 7777:localhost:7777 -f -N root@${IPADDRESS}"
/bin/bash
