@echo off
echo -- 1.3.1 --
IF "%1" == "" GOTO error
	echo Updating scripts...
	for %%i in (fn-*.sql) do mysql -D%1 -t -u root --default-character-set=utf8 < %%i

	for %%i in (sp-*.sql) do mysql -D%1 -t -u root --default-character-set=utf8 < %%i
	echo runing update-database.sql...
	mysql -D%1 -t -u root --default-character-set=utf8 < update-database.sql

goto fin

:error

echo "No se indico nombre de la base de datos, ejecute: "
echo "$ run-all timectrl"

:fin

