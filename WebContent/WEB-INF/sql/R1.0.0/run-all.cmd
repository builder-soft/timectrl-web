IF "%1" == "" GOTO error

rem echo Borrando tablas... (erase-tables.sql)
rem		mysql -D%1 -t -u root -padmin --default-character-set=utf8 < erase-tables.sql
rem echo Borrando tablas desestimadas... (erase-deprecated-object.sql)
rem 	mysql -D%1 -t -u root -padmin --default-character-set=utf8 < erase-deprecated-object.sql

call ..\msg.cmd Borrando Base de datos
	mysql -t -u root -padmin --default-character-set=utf8 -e "DROP DATABASE IF EXISTS %1;DROP DATABASE IF EXISTS bsframework;CREATE DATABASE %1;CREATE DATABASE bsframework;";

call ..\msg.cmd Creando tablas de plataforma... (create-bsframework.sql)
	mysql -D%1 -t -u root -padmin --default-character-set=utf8 < create-bsframework.sql
call ..\msg.cmd Creando tablas de sistema... (create-timectrl.sql)
	mysql -D%1 -t -u root -padmin --default-character-set=utf8 < create-timectrl.sql
	
call ..\msg.cmd Creando reglas de plataforma...(rules-bsframework.sql)
	mysql -D%1 -t -u root -padmin --default-character-set=utf8 < rules-bsframework.sql
call ..\msg.cmd Creando reglas de sistema...(rules-timectrl.sql)
	mysql -D%1 -t -u root -padmin --default-character-set=utf8 < rules-timectrl.sql
	
call ..\msg.cmd Creando funciones de sistema...
for %%i in (fn-*.sql) do mysql -D%1 -t -u root -padmin --default-character-set=utf8 < %%i

call ..\msg.cmd Creando procedimientos de sistema...
for %%i in (sp-*.sql) do mysql -D%1 -t -u root -padmin --default-character-set=utf8 < %%i
	
call ..\msg.cmd Creando datos basicos de plataforma...(data-bsframework.sql)
	mysql -D%1 -t -u root -padmin --default-character-set=utf8 < data-bsframework.sql
	
call ..\msg.cmd Creando datos basicos del sistema...(data-timectrl.sql)
	mysql -D%1 -t -u root -padmin --default-character-set=utf8 < data-timectrl.sql
	
call ..\msg.cmd Creando opciones de menu...(data-menu.sql)
	mysql -D%1 -t -u root -padmin --default-character-set=utf8 < data-menu.sql

call ..\msg.cmd Ejecutando pruebas...(testSP.sql)
	mysql -D%1 -u root -t -padmin --default-character-set=utf8 < testSP.sql

goto fin

:error
	echo No se indico nombre de la base de datos, ejecute: 
	echo $ run-all timectrl

:fin
	