echo off
mysql -u root -padmin -e "DROP DATABASE IF EXISTS timectrl;CREATE DATABASE timectrl;"
mysql -u root -padmin timectrl < backup-20150619.sql
call run-once timectrl