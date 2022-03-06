#!/bin/bash
#!/bin/sh -
true > /var/www/purgeadmin/purge.txt
curl -X POST "https://api.cloudflare.com/client/v4/zones/ZZZZZZ/purge_cache" \
-H "X-Auth-Email: EEEEEEEEE" \
-H "X-Auth-Key: kkkkkkk" \
-H "Content-Type:application/json" \
--data '{"purge_everything":true}' >> /var/www/purgeadmin/purge.txt