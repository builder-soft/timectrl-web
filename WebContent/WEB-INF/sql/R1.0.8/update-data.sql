/** Reporte semanal */

DROP PROCEDURE IF EXISTS pUpdateData_Temp;

DELIMITER $$

CREATE PROCEDURE pUpdateData_Temp()
BEGIN
#	DECLARE vIdPlainExcel BIGINT(20);
	DECLARE vIdReport BIGINT(20);
/*
	DECLARE vIdStoreProcedure BIGINT(20);
	
	SELECT cId INTO vIdPlainExcel FROM tReportOutType WHERE cKey = 'PLAIN_EXCEL';
	SELECT cId INTO vIdStoreProcedure FROM tReportParamType WHERE cKey = 'SP';
*/
	
	UPDATE tReportOutType SET cJavaClass= 'cl.buildersoft.timectrl.report.FileReport' WHERE cKey = 'FILE';
	
	INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) 
			VALUES('JASPER_FOLDER', 'Carpeta donde destan los archivos jasper', 'E:\\workspace\\timectrl-web\\WebContent\\WEB-INF\\report', (SELECT cId FROM tDataType WHERE cKey = 'STRING'));
	
	INSERT INTO tReportParamType(cKey, cName) VALUES('INTEGER', 'Valor entero');
	INSERT INTO tReportParamType(cKey, cName) VALUES('LONG', 'Valor Long');

	INSERT INTO tReport(cName, cJasperfile, cOutType) VALUES('Reporte por Semanas', 'weekly-main.jasper',
							(SELECT cId FROM tReportOutType WHERE cKey = 'FILE'));
	SET vIdReport = LAST_INSERT_ID();
	
	INSERT INTO tReportOutValue(cParam, cType, cReport, cValue)
		VALUES((SELECT cId FROM tReportOutParam WHERE cKey='OUTPUT_FILE'), 
				(SELECT cId FROM tReportOutType WHERE cKey='FILE'),
				vIdReport,
				'ReporteSemanal.xls');	
	
	INSERT INTO tReportOutValue(cParam, cType, cReport, cValue)
		VALUES(	(SELECT cId FROM tReportOutParam WHERE cKey='OUTPUT_FOLDER'), 
				(SELECT cId FROM tReportOutType WHERE cKey='FILE'),
				vIdReport,
				'E:\\temp');	
	
	INSERT INTO tReportParam(cName, cType, cReport, cValue, cFromUser, cOrder) 
		VALUES('EmployeeId', 
		(SELECT cId FROM tReportParamType WHERE cKey='LONG'), 
		vIdReport,
		'', true, 1);
	
	INSERT INTO tReportParam(cName, cType, cReport, cValue, cFromUser, cOrder) 
		VALUES('Month', 
		(SELECT cId FROM tReportParamType WHERE cKey='INTEGER'), 
		vIdReport,
		'', true, 2);

	INSERT INTO tReportParam(cName, cType, cReport, cValue, cFromUser, cOrder) 
		VALUES('Year', 
		(SELECT cId FROM tReportParamType WHERE cKey='INTEGER'), 
		vIdReport,
		'', true, 3);
		
		/***** R E P O R T E  6  ****/
	
	UPDATE tReportOutValue 
			SET cValue='Inasistencias_{Date}.xls'
			WHERE cReport=6 AND cParam=(SELECT cId FROM tReportOutParam WHERE cKey='OUTPUT_FILE');

	UPDATE tReportOutValue 
			SET cValue='MarcasPlain_{Date}.xls'
			WHERE cReport=5 AND cParam=(SELECT cId FROM tReportOutParam WHERE cKey='OUTPUT_FILE');

/*
	INSERT INTO tReportOutValue(cParam, cType, cReport, cValue)
		VALUES((SELECT cId FROM tReportOutParam WHERE cKey='OUTPUT_FILE'), 
				(SELECT cId FROM tReportOutType WHERE cKey='FILE'),
				vIdReport,
				'Inasistencias.xls');
*/

		/***** R E P O R T E  A T R A S O S  ****/
			
	INSERT INTO tReport(cName, cJasperfile, cOutType) VALUES('Reporte Atrasos', '',
							(SELECT cId FROM tReportOutType WHERE cKey = 'PLAIN_EXCEL'));
	SET vIdReport = LAST_INSERT_ID();
	
	INSERT INTO tReportOutValue(cParam, cType, cReport, cValue)
		VALUES((SELECT cId FROM tReportOutParam WHERE cKey='OUTPUT_FILE'), 
				(SELECT cId FROM tReportOutType WHERE cKey='FILE'),
				vIdReport,
				'Atrasos_{Date}.xls');
	INSERT INTO tReportOutValue(cParam, cType, cReport, cValue)
		VALUES((SELECT cId FROM tReportOutParam WHERE cKey='OUTPUT_FOLDER'), 
				(SELECT cId FROM tReportOutType WHERE cKey='FILE'),
				vIdReport,
				'E:\\temp\\timectrl');	

	INSERT INTO tReportParam(cName, cType, cReport, cValue, cOrder, cFromUser) 
		VALUES('StartDate', 
		(SELECT cId FROM tReportParamType WHERE cKey='DATE'), 
		vIdReport,
		'', 1, true);
	INSERT INTO tReportParam(cName, cType, cReport, cValue, cOrder, cFromUser) 
		VALUES('EndDate', 
		(SELECT cId FROM tReportParamType WHERE cKey='DATE'), 
		vIdReport,
		'', 2, true);

	INSERT INTO tReportParam(cName, cType, cReport, cValue, cOrder, cFromUser) 
		VALUES('Nombre SP', 
		(SELECT cId FROM tReportParamType WHERE cKey='SP'), 
		vIdReport,
		'pListLater', 0, false);
		
			
END$$

DELIMITER ;

call pUpdateData_Temp;

DROP PROCEDURE IF EXISTS pUpdateData_Temp;
