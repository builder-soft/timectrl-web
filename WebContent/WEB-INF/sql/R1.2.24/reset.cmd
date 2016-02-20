cls
mysql -u root -padmin -e "DROP DATABASE IF EXISTS ossa;CREATE DATABASE ossa;"
mysql -u root -padmin ossa < backup-ossa.txt
call run-once ossa
