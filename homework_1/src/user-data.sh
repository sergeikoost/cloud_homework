#!/bin/bash
apt-get update
apt-get install -y apache2 php libapache2-mod-php mysql-server php-mysql

systemctl enable apache2
systemctl start apache2

cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>LAMP Stack</title>
</head>
<body>
    <h1>Welcome to LAMP Stack!</h1>
    <p>Instance: $(hostname)</p>
    <p>Current time: $(date)</p>
</body>
</html>
EOF

chown www-data:www-data /var/www/html/index.html
