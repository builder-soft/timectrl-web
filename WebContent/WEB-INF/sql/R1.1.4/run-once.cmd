IF "%1" == "" GOTO error
call ..\msg.cmd "Actualizando tablas"
	mysql -D%1 -t -u root --default-character-set=utf8 < update-tables.sql
call ..\msg.cmd "Actualizando datos"
 	mysql -D%1 -t -u root --default-character-set=utf8 < update-data.sql
	
call ..\msg.cmd "Creando funciones de sistema..."
	for %%i in (fn-*.sql) do mysql -D%1 -t -u root --default-character-set=utf8 < %%i

call ..\msg.cmd "Creando procedimientos de sistema..."
	for %%i in (sp-*.sql) do mysql -D%1 -t -u root --default-character-set=utf8 < %%i
	
goto fin

:error

call ..\msg.cmd "No se indico nombre de la base de datos, ejecute: "
call ..\msg.cmd "$ run-all timectrl"

:fin

