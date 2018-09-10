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
echo "sysprep.sh abgeschlossen!"