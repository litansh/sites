#!/bin/bash
#!/bin/sh -

JQSTAT="$(jq --help | grep "foo" | wc -l)"
if [ "$JQSTAT" == "0" ];
then
yum install jq -y
fi

#--Variables
domain="$(sed -n '1p' /var/www/paramdir/paramfile)" 
email="$(sed -n '2p' /var/www/paramdir/paramfile)" 
key="$(sed -n '3p' /var/www/paramdir/paramfile)" 

cd /
curl -s -X GET "https://api.Cloudflare.com/client/v4/zones/?per_page=100" -H "X-Auth-Email: $email" -H "X-Auth-Key: $key" -H "Content-Type: application/json" | jq -r '.result[] | "\(.id) \(.name)"' | grep -w "$domain" >> /var/www/tmp.txt
dm="$(cat tmp.txt | grep $domain)"
zoneid=${dm::32}

#--API to purge cache
true > purge.txt
curl -X POST "https://api.cloudflare.com/client/v4/zones/$zoneid/purge_cache" \
-H "X-Auth-Email: $email" \
-H "X-Auth-Key: $key" \
-H "Content-Type:application/json" \
--data '{"purge_everything":true}' >> /var/www/purge.txt

rm -rf /tmp.txt
rm -rf /var/www/paramdir