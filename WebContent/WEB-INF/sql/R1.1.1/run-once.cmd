IF "%1" == "" GOTO error

echo Actualizando tablas
	mysql -D%1 -t -u root -padmin --default-character-set=utf8 < update-tables.sql
echo Actualizando datos
 	mysql -D%1 -t -u root -padmin --default-character-set=utf8 < update-data.sql
	
echo Creando funciones de sistema...
	for %%i in (fn-*.sql) do mysql -D%1 -t -u root -padmin --default-character-set=utf8 < %%i

echo Creando procedimientos de sistema...
	for %%i in (sp-*.sql) do mysql -D%1 -t -u root -padmin --default-character-set=utf8 < %%i
	
goto fin

:error

echo No se indico nombre de la base de datos, ejecute: 
echo $ run-all timectrl

:fin

echo *** FIN ***