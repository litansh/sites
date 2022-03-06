curl -X PATCH "https://api.cloudflare.com/client/v4/zones/3df7c9e1e8a656319885a3c508291171/settings/development_mode" \
-H "X-Auth-Email: gennady@cglms.com" \
-H "X-Auth-Key: 865acec931ba06e7b65dbb4102c30720cfad2" \
-H "Content-Type:application/json" \
--data '{"value":"on"}'
