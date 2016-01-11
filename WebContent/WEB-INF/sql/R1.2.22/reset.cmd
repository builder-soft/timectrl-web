mysql -u root -padmin -e "DROP DATABASE IF EXISTS rsa;CREATE DATABASE rsa;"
mysql -u root -padmin rsa < C:\cmoscoso\google-drive\timecontrol-install\RespaldoDB\RSA\bkp_rsa_timectrl_04-01-2016.txt
rem call run-once rsa
