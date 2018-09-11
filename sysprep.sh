date=`date +%s`

if grep ipv6 /etc/modules >> /dev/null ; then
 echo "IPv6 Modul bereits vorhanden."
else
 echo "IPv6 Modul nicht geladen. In /etc/modules eingetragen."
 echo ipv6 >> /etc/modules
fi

# Benoetigte Paket installieren
apt-get update
apt-get install -y openssl curl pgp openvpn zip knockd dnsutils
# EasyRSA 
if [ `apt-cache search easy-rsa | wc -l` -eq 1 ]; then  apt-get install -y easy-rsa; fi

mv /etc/openvpn /etc/openvpn_orig$date
mkdir /etc/openvpn
# nicht mehr - mount loop ln -s /tmp/easy2connect/openvpn /etc/openvpn

chmod 777 /bin/easy2connect
chmod 777 /bin/easy2connectrefresh
date=`date +%s`

touch /tmp/no_reboot

cat > /etc/knockd.conf << EOF 
[options]
	UseSyslog

[openSSH]
	sequence    = 7000,8000,9000
	seq_timeout = 5
	command     = /sbin/iptables -A INPUT -s %IP% -p tcp --dport 22 -j ACCEPT
	tcpflags    = syn

[closeSSH]
	sequence    = 9000,8000,7000
	seq_timeout = 5
	command     = /sbin/iptables -D INPUT -s %IP% -p tcp --dport 22 -j ACCEPT
	tcpflags    = syn

[easyconnectupd]
        sequence    = 12634,26374,982
        seq_timeout = 5
        command     = /bin/easy2connectrefresh
        tcpflags    = syn

[easyconnectreboot]
        sequence    = 2391,1099,43002
        seq_timeout = 5
        command     = /bin/easy2connectrefresh
        tcpflags    = syn

EOF

echo "sysprep.sh abgeschlossen!"