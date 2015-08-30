@echo off
echo -- 1.2.9 --
IF "%1" == "" GOTO error
call ..\msg.cmd "Creando funciones de sistema..."
	for %%i in (fn-*.sql) do mysql -D%1 -t -u root -padmin --default-character-set=utf8 < %%i

call ..\msg.cmd "Creando procedimientos de sistema..."
	for %%i in (sp-*.sql) do mysql -D%1 -t -u root -padmin --default-character-set=utf8 < %%i

call ..\msg.cmd "Actualizando estructuras y datos de base de datos"
	mysql -D%1 -t -u root -padmin --default-character-set=utf8 < update-database.sql

goto fin

:error

call ..\msg.cmd "No se indico nombre de la base de datos, ejecute: "
call ..\msg.cmd "$ run-all timectrl"

:fin

