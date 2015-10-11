mysql -u root -padmin -e "DROP DATABASE IF EXISTS enlasa;CREATE DATABASE enlasa;"
mysql -u root -padmin enlasa < D:\google-drive\timecontrol-install\RespaldoDB\test-unit\backup_enlasa_R1.2.10_20151001.txt
call run-once enlasa
