mysql -u root -padmin -e "DROP DATABASE IF EXISTS timectrl;CREATE DATABASE timectrl;"
mysql -u root -padmin timectrl < backup-20150618.txt
call run-once timectrl