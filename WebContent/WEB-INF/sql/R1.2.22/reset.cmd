mysql -u root -padmin -e "DROP DATABASE IF EXISTS rsa;CREATE DATABASE rsa;"
mysql -u root -padmin rsa < %GDRIVE_PATH%\timecontrol-install\RespaldoDB\RSA\07-01-2015\bkp_rsa_timectrl_07-01-2016.txt
rem call run-once rsa
