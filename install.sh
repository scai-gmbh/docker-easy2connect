echo "Die Daten werden abgerufen ..."
curl https://members.feste-ip.net/e2cbuilder/?TASK=KNOWN --data "e2cid=$e2cid&installcode=$installcode" -o /tmp/e2cbuild.tgz
if [ `ls -l /tmp/e2cbuild.tgz | tr -s " " | cut -d " " -f 5` -lt 1000 ]; then
echo " "
cat /tmp/e2cbuild.tgz
echo "Beim Abruf der Daten ist ein Fehler aufgetreten."
echo "Bitte pruefen Sie die eingegebenen Daten oder wenden Sie sich an unseren Support."
echo " "
exit
else
mkdir /etc/fipbox
cp /tmp/no_reboot /etc/fipbox/
clear
cd /etc/fipbox/ 
chmod 600 /etc/fipbox
tar xzf /tmp/e2cbuild.tgz
rm /tmp/e2cbuild.tgz
echo "Die Daten wurden abgerufen."
fi
