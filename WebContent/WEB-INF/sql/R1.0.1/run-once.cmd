IF "%1" == "" GOTO error
echo Actualizando tablas
	mysql -D%1 -t -u root --default-character-set=utf8 < update-tables.sql
echo Actualizando datos
	mysql -D%1 -t -u root --default-character-set=utf8 < update-data.sql
echo Actualizando Procedimientos Almacenados y funciones
	for %%i in (fn-*.sql) do mysql -D%1 -t -u root --default-character-set=utf8 < %%i
	for %%i in (sp-*.sql) do mysql -D%1 -t -u root --default-character-set=utf8 < %%i


	mysql -D%1 -u root -t --default-character-set=utf8 < testSP.sql
	
	
goto fin

:error
	echo No se indico nombre de la base de datos, ejecute: 
	echo $ run-all timectrl

:fin
echo *** FIN ***