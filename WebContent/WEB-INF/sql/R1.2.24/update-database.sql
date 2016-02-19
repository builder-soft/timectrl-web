insert into tEventType(cKey, cName) VALUES('BUILD_REPORT', 'Ejecución de reporte');
insert into tEventType(cKey, cName) VALUES('UPDATE_USER', 'Actualizacion de usuario');

drop table tFileContent;
drop table tFile;
drop table ttimectrl;


DELIMITER $$
create procedure pUpdateData_Temp()
begin
	DECLARE vTemp BIGINT(20);
 
	update tOption set cEnable = false where ckey = 'CH_PASS';
	
	delete from toption where ckey = 'FILES';
	insert into tOption(cKey, cLabel, cURL, cParent, cType, cOrder, cEnable, cIsAdmin) VALUES('FILES', 'Archivos', NULL, NULL, 1, 1, true, 0);
	
	update tOption SET cURL = null, cParent=35 WHERE cKey = 'EMPLOYEE';
	
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
	
	
	
	
	update tOption SET cenable=false WHERE cKey = 'SYSTEM';
END$$
DELIMITER ;

call pUpdateData_Temp;

drop procedure if exists pUpdateData_Temp;




UPDATE tVersion SET cVersion='1.2.24', cUpdated=NOW() WHERE cKey = 'DBT';


