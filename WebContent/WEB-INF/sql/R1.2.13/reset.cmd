mysql -u root -padmin -e "DROP DATABASE IF EXISTS rsa;CREATE DATABASE rsa;"
mysql -u root -padmin rsa < C:\cmoscoso\google-drive\timecontrol-install\RespaldoDB\test-unit\backup_enlasa_R1.2.10_20151001.txt
call run-once rsa
