update tOption set cLabel='Sistema' where cId=1;
update tOption set cLabel='Usuarios' where cid=2;
update tOption set cLabel='Permisos de roles' where cid=3;
update tOption set cLabel='Cambio de clave' where cid=4;
update tOption set cLabel='Roles' where cid=5;
update tOption set cLabel='Parámetros' where cid=6; 
update tOption set cLabel='Configuración del Sistema' where cid=7; 
update tOption set cLabel='Empleados' where cid=8;
update tOption set cLabel='Tablas' where cid=9;
update tOption set cLabel='Cargos' where cid=10;
update tOption set cLabel='Areas' where cid=11;
update tOption set cLabel='Config. Turnos' where cid=12;
update tOption set cLabel='Feriados' where cid=13;
update tOption set cLabel='Relojes' where cid=14;
update tOption set cLabel='Permisos y licencias' where cid=15;
update tOption set cLabel='Consultas y Reportes' where cid=16;
update tOption set cLabel='Archivos' where cid=17;
update tOption set cLabel='Resumenes' where cid=18;
update tOption set cLabel='Detalles' where cid=19;
update tOption set cLabel='Reporte de Asistencia' where cid=20;
update tOption set cLabel='Reporte por Semana' where cid=21;
update tOption set cLabel='Reporte Completo (xls)' where cid=22;
update tOption set cLabel='Reporte Atrasos' where cid=23;
update tOption set cLabel='Reporte Inasistencias' where cid=24;
update tOption set cLabel='Configuración reportes' where cid=25;
update tOption set cLabel='Tipos de salida' where cid=26;
update tOption set cLabel='Tipos de parametros' where cid=27;
update tOption set cLabel='Lista de Reportes' where cid=28;

/** Reporte de inasistencias */

DROP PROCEDURE IF EXISTS pUpdateData_Temp;

DELIMITER $$

CREATE PROCEDURE pUpdateData_Temp()
BEGIN
	DECLARE vIdPlainExcel BIGINT(20);
	DECLARE vIdStoreProcedure BIGINT(20);
	DECLARE vIdReport BIGINT(20);
	SELECT cId INTO vIdPlainExcel FROM tReportOutType WHERE cKey = 'PLAIN_EXCEL';
	SELECT cId INTO vIdStoreProcedure FROM tReportParamType WHERE cKey = 'SP';
	
	INSERT INTO tReport(cName, cJasperfile, cOutType) VALUES('Reporte Inasistencias', '', vIdPlainExcel);
	SET vIdReport = LAST_INSERT_ID();
	
	INSERT INTO tReportOutValue(cParam, cType, cReport, cValue)
		VALUES((SELECT cId FROM tReportOutParam WHERE cKey='OUTPUT_FILE'), 
				(SELECT cId FROM tReportOutType WHERE cKey='FILE'),
				vIdReport,
				'Inasistencias.xls');	
	
	INSERT INTO tReportOutValue(cParam, cType, cReport, cValue)
		VALUES((SELECT cId FROM tReportOutParam WHERE cKey='OUTPUT_FOLDER'), 
				(SELECT cId FROM tReportOutType WHERE cKey='FILE'),
				vIdReport,
				'E:\\temp\\timectrl');	
	
	INSERT INTO tReportParam(cName, cType, cReport, cValue, cOrder) 
		VALUES('absenceDate', 
		(SELECT cId FROM tReportParamType WHERE cKey='DATE'), 
		vIdReport,
		'', 1);
				
	INSERT INTO tReportParam(cName, cType, cReport, cValue, cFromUser, cOrder) 
		VALUES('Nombre SP', 
		vIdStoreProcedure, 
		vIdReport,
		'pAbsence', false, 0);
				
END$$

DELIMITER ;

call pUpdateData_Temp;

DROP PROCEDURE IF EXISTS pUpdateData_Temp;