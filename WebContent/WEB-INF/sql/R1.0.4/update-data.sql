/**  R E P O R E T E   P L A N O  */
DELETE FROM tParameter WHERE cKey ='PLAIN_REPORT';

INSERT INTO tReportOutType(cName, cKey) VALUES('Listado Excel', 'PLAIN_EXCEL');
SET @outTypeId = LAST_INSERT_ID();

INSERT INTO tReportOutParam(cName, cType, cKey) VALUES('Carpeta de Salida', @outTypeId,'OUTPUT_FOLDER');

INSERT INTO tReport(cName, cJasperfile, cOutType) VALUES('Reporte de Marcas', '', @outTypeId);
SET @idReport = LAST_INSERT_ID();

INSERT INTO tReportOutValue(cParam, cType, cReport, cValue)
	VALUES((SELECT cId FROM tReportOutParam WHERE cKey='OUTPUT_FILE'), 
			(SELECT cId FROM tReportOutType WHERE cKey='FILE'),
			@idReport,
			'MarcasPlain.xls');

INSERT INTO tReportOutValue(cParam, cType, cReport, cValue)
	VALUES((SELECT cId FROM tReportOutParam WHERE cKey='OUTPUT_FOLDER' LIMIT 1), 
			(SELECT cId FROM tReportOutType WHERE cKey='FILE' LIMIT 1),
			@idReport,
			'E:\\temp\\timectrl');

INSERT INTO tReportParamType(cKey, cName) VALUES('SP', 'Store Procedure');
SET @idSPName = LAST_INSERT_ID();

INSERT INTO tReportParam(cName, cType, cReport, cValue, cOrder) 
	VALUES('StartDate', 
	(SELECT cId FROM tReportParamType WHERE cKey='DATE'), 
	@idReport,
	'', 1);

INSERT INTO tReportParam(cName, cType, cReport, cValue, cOrder) 
	VALUES('EndDate', 
	(SELECT cId FROM tReportParamType WHERE cKey='DATE'), 
	@idReport,
	'', 2);
	
INSERT INTO tReportParam(cName, cType, cReport, cValue, cFromUser, cOrder) 
	VALUES('Nombre SP', 
	@idSPName, 
	@idReport,
	'pListAttendanceAsExcel3', false, 0);
	

/**   R E P O R T E   S E M A N A L   */
/**Archivo de reporte de asistencia*/

