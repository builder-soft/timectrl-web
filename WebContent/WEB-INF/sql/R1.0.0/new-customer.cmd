IF "%1" == "" GOTO error
	call ..\msg.cmd "Creando base de datos %1... (create-timectrl.sql)"
	mysql -t -u root -padmin --default-character-set=utf8 -e "DROP DATABASE IF EXISTS %1;CREATE DATABASE %1;";

	call ..\msg.cmd "Creando tablas de sistema... (create-timectrl.sql)"
	mysql -D%1 -t -u root -padmin --default-character-set=utf8 < create-timectrl.sql
	
	mysql -t -u root -padmin --default-character-set=utf8 -e "INSERT INTO bsframework.tDomain(cName, cDatabase) VALUES('%1', '%1');SET @domainId = LAST_INSERT_ID();SELECT cId INTO @userId FROM bsframework.tUser WHERE cMail='admin';INSERT INTO bsframework.tR_UserDomain(cUser, cDomain) VALUES(@userId, @domainId);INSERT INTO bsframework.tDomainAttribute(cDomain, cKey, cName, cValue) VALUES(@domainId, 'database.driver', 'Driver', 'org.gjt.mm.mysql.Driver');INSERT INTO bsframework.tDomainAttribute(cDomain, cKey, cName, cValue) VALUES(@domainId, 'database.server', 'Server', 'localhost');INSERT INTO bsframework.tDomainAttribute(cDomain, cKey, cName, cValue) VALUES(@domainId, 'database.database', 'Database', '%1');INSERT INTO bsframework.tDomainAttribute(cDomain, cKey, cName, cValue) VALUES(@domainId, 'database.username', 'User', 'root');INSERT INTO bsframework.tDomainAttribute(cDomain, cKey, cName, cValue) VALUES(@domainId, 'database.password', 'Password', 'admin');"

	call ..\msg.cmd Creando reglas de sistema...(rules-timectrl.sql)
	mysql -D%1 -t -u root -padmin --default-character-set=utf8 < rules-timectrl.sql
	
	call ..\msg.cmd Creando funciones de sistema...
	for %%i in (fn-*.sql) do mysql -D%1 -t -u root -padmin --default-character-set=utf8 < %%i
	
	call ..\msg.cmd Creando procedimientos de sistema...
	for %%i in (sp-*.sql) do mysql -D%1 -t -u root -padmin --default-character-set=utf8 < %%i
		
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
	