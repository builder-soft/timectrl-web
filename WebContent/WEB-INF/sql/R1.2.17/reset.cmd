mysql -u root -padmin -e "DROP DATABASE IF EXISTS rsa;CREATE DATABASE rsa;"
mysql -u root -padmin rsa < %GDRIVE_PATH%\timectrl-cloud\backup-database\backup-rsa-20151103.txt
call run-once rsa
