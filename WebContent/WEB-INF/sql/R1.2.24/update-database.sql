insert into tEventType(cKey, cName) VALUES('BUILD_REPORT', 'Ejecución de reporte');
insert into tEventType(cKey, cName) VALUES('UPDATE_USER', 'Actualizacion de usuario');
insert into tEventType(cKey, cName) VALUES('SECURITY_CH_PASS', 'Cambio de password');

drop table if exists tFileContent;
drop table if exists tFile;
drop table if exists ttimectrl;

DELIMITER $$
create procedure pUpdateData_Temp()
begin
	DECLARE vTemp BIGINT(20);
 
	update tOption set cEnable = false where ckey = 'CH_PASS';
	
	delete from toption where ckey = 'FILES';
	insert into tOption(cKey, cLabel, cURL, cParent, cType, cOrder, cEnable, cIsAdmin) VALUES('FILES', 'Archivos', NULL, NULL, 1, 1, true, 0);
	
	SELECT cID INTO vTemp FROM tOption WHERE cKey = 'FILES';
	update tOption SET cURL = null, cParent=vTemp WHERE cKey = 'EMPLOYEE';
	
	SELECT cID INTO vTemp FROM tOption WHERE cKey = 'EMPLOYEE';
	
	insert into tOption(cKey, cLabel, cURL, cParent, cType, cOrder, cEnable, cIsAdmin) 
	VALUES('EMPLOYEE_DATA', 'Datos Básicos', '/servlet/config/employee/EmployeeManager', vTemp, 1, 1, true, 0);
	
	insert into tOption(cKey, cLabel, cURL, cParent, cType, cOrder, cEnable, cIsAdmin) 
	VALUES('EMPLOYEE_LICENSE', 'Licencias', '/servlet/config/employee/EmployeeLicenseManager', vTemp, 1, 2, true, 0);

	insert into tOption(cKey, cLabel, cURL, cParent, cType, cOrder, cEnable, cIsAdmin) 
	VALUES('EMPLOYEE_TURN', 'Turnos', '/servlet/config/employee/EmployeeTurnManager', vTemp, 1, 3, true, 0);
	
	insert into tOption(cKey, cLabel, cURL, cParent, cType, cOrder, cEnable, cIsAdmin) 
	VALUES('EMPLOYEE_MARK', 'Marcas', '/servlet/config/employee/EmployeeMarkManager', vTemp, 1, 4, true, 0);
	
	insert into tOption(cKey, cLabel, cURL, cParent, cType, cOrder, cEnable, cIsAdmin) 
	VALUES('EMPLOYEE_DETACHED', 'Desvinculado', '/servlet/config/employee/EmployeeDetachedManager', vTemp, 1, 5, true, 0);

	SELECT cID INTO vTemp FROM tOption WHERE cKey = 'FILES';
	update tOption SET cParent = vTemp WHERE cKey = 'POST';
	update tOption SET cParent = vTemp WHERE cKey = 'AREA';
	update tOption SET cParent = vTemp WHERE cKey = 'FISCAL_DATE';
	update tOption SET cParent = vTemp WHERE cKey = 'LICENSE_CAUSE';
	update tOption SET cParent = vTemp WHERE cKey = 'GROUP_MGR';	
	
	update tOption SET cLabel = 'Configuración' WHERE cKey = 'CONFIG';
	SELECT cID INTO vTemp FROM tOption WHERE cKey = 'CONFIG';
	insert into tOption(cKey, cLabel, cURL, cParent, cType, cOrder, cEnable, cIsAdmin) 
	VALUES('SECURITY', 'Seguridad', NULL, vTemp, 1, 1, true, 0);
	insert into tOption(cKey, cLabel, cURL, cParent, cType, cOrder, cEnable, cIsAdmin) 
	VALUES('DOMAIN', 'Dominio', NULL, vTemp, 1, 2, true, 0);
	insert into tOption(cKey, cLabel, cURL, cParent, cType, cOrder, cEnable, cIsAdmin) 
	VALUES('ATTENDANCE', 'Asistencia', NULL, vTemp, 1, 3, true, 0);

	SELECT cID INTO vTemp FROM tOption WHERE cKey = 'SECURITY';
	update tOption SET cParent = vTemp WHERE cKey = 'USER';
	update tOption SET cParent = vTemp WHERE cKey = 'ROL';
	update tOption SET cParent = vTemp WHERE cKey = 'ALLOW';

	SELECT cID INTO vTemp FROM tOption WHERE cKey = 'DOMAIN';
	update tOption SET cParent = vTemp, cOrder=1 WHERE cKey = 'DOMAIN_MGR';
	update tOption SET cParent = vTemp, cOrder=2 WHERE cKey = 'PARAMS';
	update tOption SET cParent = vTemp, cOrder=3 WHERE cKey = 'DOMAIN_ATTR_MGR';
	
	SELECT cID INTO vTemp FROM tOption WHERE cKey = 'ATTENDANCE';
	update tOption SET cParent = vTemp, cOrder=1 WHERE cKey = 'TURN';
	update tOption SET cParent = vTemp, cOrder=2 WHERE cKey = 'MACHINE';
	update tOption SET cParent = vTemp, cOrder=3, cLabel='Reportes' WHERE cKey = 'REP_CONFIG';
	
	SELECT cID INTO vTemp FROM tOption WHERE cKey = 'REPORT';
	update tOption SET cParent = vTemp, cOrder=1 WHERE cKey = 'EVENT_VIEWER';

	
	SELECT cID INTO vTemp FROM tOption WHERE cKey = 'ATTENDANCE';
	update tOption SET cParent = vTemp, cOrder=3 WHERE cKey = 'REP_LIST';

	update tOption SET cenable=false WHERE cKey = 'SYSTEM';
	update tOption SET cenable=false WHERE cKey = 'TABLES';
	update tOption SET cenable=false WHERE cKey = 'REP_CONFIG';
	
	update tOption SET cOrder=2 WHERE cKey ='POST';
	update tOption SET cOrder=3 WHERE cKey ='AREA';
	update tOption SET cOrder=4 WHERE cKey ='FISCAL_DATE';
	update tOption SET cOrder=5 WHERE cKey ='LICENSE_CAUSE';
	update tOption SET cOrder=6 WHERE cKey ='GROUP_MGR';
	
	update tOption SET cOrder=2 WHERE cKey ='REP_ASIST';
	update tOption SET cOrder=3 WHERE cKey ='REP_WEEKLY';
	update tOption SET cOrder=4 WHERE cKey ='REP_PLAIN';
	update tOption SET cOrder=5 WHERE cKey ='REP_LATE';
	update tOption SET cOrder=6 WHERE cKey ='REP_ABSENCE';
	update tOption SET cOrder=7 WHERE cKey ='EXECUTE_REPORT';

	update tOption SET cLabel='Dominios' WHERE cKey ='DOMAIN';
	update tOption SET cLabel='Definición' WHERE cKey ='DOMAIN_MGR';
	update tOption SET cLabel='Atributos' WHERE cKey ='DOMAIN_ATTR_MGR';
	update tOption SET cLabel='Otros Reportes' WHERE cKey ='EXECUTE_REPORT';
	update tOption SET cLabel='Reporte Completo (Excel)' WHERE cKey ='REP_PLAIN';
	update tOption SET cLabel='Reportes' WHERE cKey ='REP_LIST';
	update tOption SET cLabel='Turnos' WHERE cKey ='TURN';
	
END$$
DELIMITER ;

call pUpdateData_Temp;

drop procedure if exists pUpdateData_Temp;

truncate table tr_roloption;

insert into tr_roloption
select 1, cId from tOption;


INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('PASS_MIN_LEN', 'Largo mínimo de password', '6', (select cid from tdatatype where ckey='Integer'));
INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('PASS_SPEC_CHR', 'Cantidad mínima de caracteres especiales (.,$#)', '1', (select cid from tdatatype where ckey='Integer'));
INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('PASS_UPPER_CHR', 'Cantidad mínima de letras en mayusculas', '1', (select cid from tdatatype where ckey='Integer'));
INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('PASS_NUM_CHR', 'Cantidad mínima de números en la password', '1', (select cid from tdatatype where ckey='Integer'));

INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('PASS_CHANGE_DAYS', 'Días para la expiración de password', '90', (select cid from tdatatype where ckey='Integer'));


DELIMITER $$
create procedure pUpdateData_Temp()
begin

	IF NOT EXISTS(	SELECT * 
				FROM information_schema.COLUMNS 
				WHERE TABLE_SCHEMA = 'bsframework' 
					AND TABLE_NAME = 'tUser' 
					AND COLUMN_NAME = 'cLastChangePass') THEN
		ALTER TABLE bsframework.tUser
		ADD COLUMN cLastChangePass DATE NULL AFTER cAdmin;
		
		UPDATE bsframework.tUser SET cLastChangePass = NOW();
		
	END IF;
END$$
DELIMITER ;

call pUpdateData_Temp;
drop procedure if exists pUpdateData_Temp;



UPDATE tVersion SET cVersion='1.2.24', cUpdated=NOW() WHERE cKey = 'DBT';


