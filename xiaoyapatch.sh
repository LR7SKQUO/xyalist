#!/bin/sh
sed_string_escape() {
    local search="$1"
    local searchEscaped=$(printf '%s\n' "$search" | sed -e 's/[]\/$*.^[]/\\&/g');
    echo $searchEscaped
}

sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
apk add --no-cache zip

rm -rf /var/lib/aaa
mkdir /var/lib/aaa
cd /var/lib/aaa
unzip -q /var/lib/data.zip

sedSearch=$(sed_string_escape 'proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=apicache:10m inactive=10m;')
sed -i "s/$sedSearch//g" /var/lib/aaa/nginx.conf
sedSearch=$(sed_string_escape 'proxy_cache apicache;')
sed -i "s/$sedSearch//g" /var/lib/aaa/nginx.conf

cd /var/lib/aaa
zip -q -r html.zip *
mv html.zip /var/lib/data.zip

chown -R nginx /var/cache/nginx/
chmod -R 777 /var/cache/nginx/

cd /
rm -rf /var/lib/aaa

echo 'Done. Please restart the docker container.'

