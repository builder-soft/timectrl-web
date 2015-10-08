mysql -u root -padmin -e "DROP DATABASE IF EXISTS rsa;CREATE DATABASE rsa;"
mysql -u root -padmin rsa < C:\cmoscoso\google-drive\timecontrol-install\RespaldoDB\test-unit\backup_rsa_R1.2.12_20151008.txt
call run-once rsa
