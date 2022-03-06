#!/bin/bash
#!/bin/sh -

#--Check JQ is installed
JQSTAT="$(jq --help | grep "foo" | wc -l)"
if [ "$JQSTAT" == "0" ];
then
yum install jq -y
fi

#--Variables
domain="$(sed -n '1p' /var/www/purgeadmin/paramdir/paramfile)"

rm -rf /var/www/purgeadmin/purge.txt

exist="$(ls /var/www/ | grep "$domain" | wc -l)"
if [ "$exist" != "0" ];
then 
if [ "$domain" == "litanshamir.com" ];
then
email="litansh@gmail.com"
key="000ff94c063a8ad911ac223ea230dfd44aff1"
fi
###
fi

#--Get Zone ID of domain
cd /
dm="$(curl -s -X GET "https://api.Cloudflare.com/client/v4/zones/?per_page=100" -H "X-Auth-Email: $email" -H "X-Auth-Key: $key" -H "Content-Type: application/json" | jq -r '.result[] | "\(.id) \(.name)"' | grep -w "$domain")"
zoneid=${dm::32}

#--API to purge cache
cp /var/www/purgeadmin/postapi.sh /var/www/purgeadmin/postapitmp.sh

sed -i "s/EEEEEEEEE/$email/g" /var/www/purgeadmin/postapitmp.sh
sed -i "s/kkkkkkk/$key/g" /var/www/purgeadmin/postapitmp.sh
sed -i "s/ZZZZZZ/$zoneid/g" /var/www/purgeadmin/postapitmp.sh

chmod -R 755 /var/www/purgeadmin/postapitmp.sh
chmod +x /var/www/purgeadmin/postapitmp.sh
cd /var/www/purgeadmin && sh postapitmp.sh

rm -rf /var/www/purgeadmin/paramdir
rm -rf /var/www/purgeadmin/postapitmp.sh
rm -rf /var/www/purgeadmin/tmp.txt
