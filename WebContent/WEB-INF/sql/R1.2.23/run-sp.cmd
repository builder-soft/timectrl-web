IF "%1" == "" GOTO error
	for %%i in (fn-*.sql) do mysql -D%1 -u root -t -padmin --default-character-set=utf8 < %%i
	for %%i in (sp-*.sql) do mysql -D%1 -u root -t -padmin --default-character-set=utf8 < %%i
	
	mysql -D%1 -u root -t -padmin --default-character-set=utf8 < testSP.sql

	goto fin

:error
	echo No se indico nombre de la base de datos, ejecute: 
	echo $ run-sp DataBaseName

:fin
	echo ***********
	echo *** FIN ***
	echo ***********
	