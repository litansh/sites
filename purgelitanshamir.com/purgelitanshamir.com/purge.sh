#!/bin/bash
#!/bin/sh -

#--Check JQ is installed
JQSTAT="$(jq --help | grep "foo" | wc -l)"
if [ "$JQSTAT" == "0" ];
then
yum install jq -y
fi

#--Variables
sub="$(sed -n '1p' /var/www/paramdir/paramfile)"
prefix="purge."
domain=${sub#"$prefix"}

mv /var/www/paramdir /var/www/purge$domain
rm -rf /var/www/purge$domain/purge.txt

email="$(sed -n '2p' /var/www/purge$domain/paramdir/paramfile)"
key="$(sed -n '3p' /var/www/purge$domain/paramdir/paramfile)"

#--Get Zone ID of domain
cd /
dm="$(curl -s -X GET "https://api.Cloudflare.com/client/v4/zones/?per_page=100" -H "X-Auth-Email: $email" -H "X-Auth-Key: $key" -H "Content-Type: application/json" | jq -r '.result[] | "\(.id) \(.name)"' | grep -w "$domain" >> /var/www/purge$domain/tmp.txt | grep $domain)"
zoneid=${dm::32}

#--API to purge cache
cat >/var/www/purge$domain/postapi.sh <<-"EOF"
#!/bin/bash
curl -X POST "https://api.cloudflare.com/client/v4/zones/ZZZZZZ/purge_cache" -H "X-Auth-Email: EEEEEEEEE -H "X-Auth-Key: kkkkkkk" -H "Content-Type:application/json" --data '{"purge_everything":true}' >> /var/www/purge.txt
EOF

sed -i "s/EEEEEEEEE/$email/g" /var/www/purge$domain/postapi.sh
sed -i "s/kkkkkkk/$key/g" /var/www/purge$domain/postapi.sh
sed -i "s/ZZZZZZ/$zoneid/g" /var/www/purge$domain/postapi.sh

mv /var/www/purge.txt /var/www/purge$domain

chmod -R 755 /var/www/purge$domain/postapi.sh
chmod +x /var/www/purge$domain/postapi.sh
cd /var/www/purge$domain && sh postapi.sh

rm -rf /var/www/purge$domain/paramdir
rm -rf /var/www/purge$domain/postapi.sh
rm -rf /var/www/purge$domain/tmp.txt
