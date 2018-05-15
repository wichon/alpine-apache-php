#!/bin/sh

# Enable commonly used apache modules
sed -i 's/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/' /etc/apache2/httpd.conf
sed -i 's/#LoadModule\ deflate_module/LoadModule\ deflate_module/' /etc/apache2/httpd.conf
sed -i 's/#LoadModule\ expires_module/LoadModule\ expires_module/' /etc/apache2/httpd.conf

sed -i "s#^DocumentRoot \".*#DocumentRoot \"/app/$WEBAPP_ROOT\"#g" /etc/apache2/httpd.conf
sed -i "s#/var/www/localhost/htdocs#/app/$WEBAPP_ROOT#" /etc/apache2/httpd.conf
printf "\n<Directory \"/app/$WEBAPP_ROOT\">\n\tAllowOverride All\n</Directory>\n" >> /etc/apache2/httpd.conf

# Logs redirection configuration via LOG_CONF environment variable
case $LOG_CONF in
    # Redirect all logs (access and errors) to stdout and stderr
    "all")
        ln -sf /dev/stdout /var/log/apache2/access.log
        ln -sf /dev/stderr /var/log/apache2/error.log
        ;;
    # Redirect error logs stderr
    "error")
        ln -sf /dev/stderr /var/log/apache2/error.log
        ;;
    # Redirect access logs stdout
    "access")
        ln -sf /dev/stdout /var/log/apache2/access.log
        ;;
    # Default, don't redirect log files, apache logs will still be accesible inside the container
    *)
        ;;
esac

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
