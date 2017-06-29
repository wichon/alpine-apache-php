#!/bin/sh

# Enable commonly used apache modules
sed -i 's/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/' /etc/apache2/httpd.conf
sed -i 's/#LoadModule\ deflate_module/LoadModule\ deflate_module/' /etc/apache2/httpd.conf
sed -i 's/#LoadModule\ expires_module/LoadModule\ expires_module/' /etc/apache2/httpd.conf

sed -i "s#^DocumentRoot \".*#DocumentRoot \"/app/$WEBAPP_ROOT\"#g" /etc/apache2/httpd.conf
sed -i "s#/var/www/localhost/htdocs#/app/$WEBAPP_ROOT#" /etc/apache2/httpd.conf
printf "\n<Directory \"/app/$WEBAPP_ROOT\">\n\tAllowOverride All\n</Directory>\n" >> /etc/apache2/httpd.conf

if [ -z "$WEBAPP_USER_ID" ]; then
    chown -R apache:apache /app
else
    # Override apache user under which apache runs its child processes with the one provided
    # Useful for running container in development mode enabling live code modification
    runApacheAsUser=webapp
    apacheConfigPath="/etc/apache2/httpd.conf"
    addgroup -g $WEBAPP_USER_ID $runApacheAsUser
    adduser -D -H -g "webapp user" -G $runApacheAsUser -u $WEBAPP_USER_ID $runApacheAsUser
    chown -R $WEBAPP_USER_ID:$WEBAPP_USER_ID /app    
    sed -i "s/User apache/User $runApacheAsUser/" $apacheConfigPath
    sed -i "s/Group apache/Group $runApacheAsUser/" $apacheConfigPath
fi

httpd -D FOREGROUND
