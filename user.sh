# Secure MariaDB and create user/database
sudo mysql -u root <<EOF
CREATE USER 'root1'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'admin';
GRANT CREATE, ALTER, DROP, INSERT, UPDATE, DELETE, SELECT, REFERENCES, RELOAD on *.* TO 'root1'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;

ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'admin';
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'admin';
SELECT user, authentication_string, plugin, host FROM mysql.user;
EOF
pause 10

# Create database
sudo mysql -u root1 -p'admin' <<EOF
CREATE DATABASE chat_system CHARACTER SET utf8;
exit
EOF