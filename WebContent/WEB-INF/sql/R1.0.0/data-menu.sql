SELECT cId INTO @rolId FROM tRol WHERE cName = 'Administrador';

/** Opciones para perfilar y crear usuarios */
INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('SYSTEM', 'Sistema', NULL, NULL, 1);
SET @menuIdSystem = LAST_INSERT_ID();
INSERT INTO tR_RolOption(cRol, cOption) VALUES(@rolId, @menuIdSystem);
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('USER', 'Usuarios', '/servlet/system/user/UserManager', @menuIdSystem, 1);
	INSERT INTO tR_RolOption(cRol, cOption) VALUES(@rolId, LAST_INSERT_ID());
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('ALLOW', 'Permisos de roles', '/servlet/system/roleDef/RoleDef', @menuIdSystem, 3);
	INSERT INTO tR_RolOption(cRol, cOption) VALUES(@rolId, LAST_INSERT_ID());
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('CH_PASS', 'Cambio de clave', '/servlet/system/changepassword/SearchPassword', @menuIdSystem, 4);
	INSERT INTO tR_RolOption(cRol, cOption) VALUES(@rolId, LAST_INSERT_ID());
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('ROL', 'Roles', '/servlet/system/role/RolManager', @menuIdSystem, 2);
	INSERT INTO tR_RolOption(cRol, cOption) VALUES(@rolId, LAST_INSERT_ID());
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('PARAMS', 'Parámetros', '/servlet/config/systemparams/ParameterManager', @menuIdSystem, 5);
	INSERT INTO tR_RolOption(cRol, cOption) VALUES(@rolId, LAST_INSERT_ID());

/*********************************************/
INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('CONFIG', 'Configuracion del Sistema', NULL, NULL, 2);
SET @menuIdConfig = LAST_INSERT_ID();
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('EMPLOYEE', 'Empleados', '/servlet/config/employee/EmployeeManager', @menuIdConfig, 1);
	SET @menuIdEmployee = LAST_INSERT_ID();

	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('TABLES', 'Tablas', NULL, @menuIdConfig, 2);
	SET @menuIdTables = LAST_INSERT_ID();

	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('POST', 'Cargos', '/servlet/config/employee/PostManager', @menuIdTables, 1);
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('AREA', 'Areas', '/servlet/config/employee/AreaManager', @menuIdTables, 2);
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('TURN', 'Config. Turnos', '/servlet/timectrl/turns/TurnManager', @menuIdTables, 3);
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('FISCAL_DATE', 'Feriados', '/servlet/timectrl/fiscalDate/FiscalDateManager', @menuIdTables, 4);
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('MACHINE', 'Relojes', '/servlet/timectrl/machine/MachineManager', @menuIdTables, 5);
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('LICENSE_CAUSE', 'Permisos y licencias', '/servlet/timectrl/licenseCause/LicenseCauseManager', @menuIdTables, 6);	

/*********************************************/
INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('REPORT', 'Consultas y Reportes', NULL, NULL, 3);
SET @menuIdReport = LAST_INSERT_ID();
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('FILES', 'Archivos', '/servlet/timectrl/files/FilesManager', @menuIdReport, 1);
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('SUMMARY', 'Resumenes', '/servlet/timectrl/report/Summary', @menuIdReport, 2);
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('DETAIL', 'Detalles', NULL, @menuIdReport, 3);
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('REP_ASIST', 'Reporte de asistencia', '/servlet/timectrl/report/AttendanceReport', @menuIdReport, 4);
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('REP_WEEKLY', 'Reporte de asistencia, por semanas', '/servlet/timectrl/report/WeeklyReport', @menuIdReport, 5);
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('REP_PLAIN', 'Reporte Plano', '/servlet/timectrl/report/PlainReport', @menuIdReport, 6);
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('REP_LATE', 'Reporte de retrazados', '/servlet/timectrl/report/LateReport', @menuIdReport, 7);
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('REP_ABSENCE', 'Reporte de Inasistencias', '/servlet/timectrl/report/AbsenceReport', @menuIdReport, 8);
	
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('REP_CONFIG', 'Configuración reportes', NULL, @menuIdReport, 8);
	SET @configReport = LAST_INSERT_ID();
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('REP_CFG_OUT_TYPE', 'Tipos de salida', '/servlet/timectrl/report/config/ReportOutTypeManager', @configReport, 3);
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('REP_CFG_PRM_TYPE', 'Tipos de parametros', '/servlet/timectrl/report/config/ReportParamTypeManager', @configReport, 2);
	INSERT INTO tOption(cKey, cLabel, cUrl, cParent, cOrder) VALUES('REP_LIST', 'Lista de Reportes', '/servlet/timectrl/report/config/ReportManager', @configReport, 1);
	
	
	
/** Creacion de usuario contador del sistema, con las opciones desarrolladas 
hasta ahora */

SELECT	cId
INTO	@domainId 
FROM	bsframework.tDomain
LIMIT 0,1;

/**
INSERT INTO bsframework.tUser(cMail, cName, cPassword) VALUES('conta', 'Contador Principal', md5('conta'));
SET @userId = LAST_INSERT_ID();
INSERT INTO bsframework.tR_UserDomain(cUser, cDomain) VALUES(@userId, @domainId);

INSERT INTO tRol(cName) VALUES('Contador');
SET @rolId = LAST_INSERT_ID();

INSERT INTO tR_UserRol(cUser, cRol) VALUES(@userId, @rolId);

INSERT INTO tR_RolOption(cRol, cOption) VALUES(@rolId,6);
INSERT INTO tR_RolOption(cRol, cOption) VALUES(@rolId,7);
INSERT INTO tR_RolOption(cRol, cOption) VALUES(@rolId,11);
INSERT INTO tR_RolOption(cRol, cOption) VALUES(@rolId,13);
INSERT INTO tR_RolOption(cRol, cOption) VALUES(@rolId,16);
INSERT INTO tR_RolOption(cRol, cOption) VALUES(@rolId,33);
INSERT INTO tR_RolOption(cRol, cOption) VALUES(@rolId,34);
INSERT INTO tR_RolOption(cRol, cOption) VALUES(@rolId,35);
INSERT INTO tR_RolOption(cRol, cOption) VALUES(@rolId,36);
INSERT INTO tR_RolOption(cRol, cOption) VALUES(@rolId,38);
*/
