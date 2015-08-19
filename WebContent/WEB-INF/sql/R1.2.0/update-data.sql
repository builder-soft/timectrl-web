UPDATE tReport SET cKey='WEEKLY' WHERE cId=7;
INSERT INTO tParameter (cKey, cLabel, cValue, cDataType) VALUES('EMPLOYEE_ORDER', 'Campo con el que se ordenan los empleados. default "CAST(tEmployee.cKey AS UNSIGNED)"', 'cRut', (select cid from tdatatype where ckey='String'));

INSERT INTO tOption (cKey, cLabel, cUrl, cParent, cType, cOrder) VALUES('EXECUTE_REPORT', 'Ejecución de reportes', '/servlet/timectrl/report/execute/ExecutionReport', 16, 1, 10);

delete from tr_roloption where coption=(select cid from tOption where cKey = 'REP_CFG_PRM_TYPE');
delete from tOption where cKey = 'REP_CFG_PRM_TYPE';

UPDATE tReportInParam SET cLabel=cName;

UPDATE tOption SET cUrl = '/servlet/timectrl/report/config/ReportTypeManager' WHERE cKey = 'REP_CFG_OUT_TYPE';
UPDATE tOption SET cLabel='Tipos de reportes' where cKey = 'REP_CFG_OUT_TYPE';

UPDATE tOption SET cEnable = FALSE WHERE cKey IN ('FILES','SUMMARY','DETAIL', 'REP_CONFIG', 'EXECUTE_REPORT', 'REP_CONFIG');

/**
INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) 
		VALUES('JASPER_FOLDER', 'Carpeta donde destan los archivos jasper', 'd:\\workspace\\timectrl-web\\WebContent\\WEB-INF\\report', (SELECT cId FROM tDataType WHERE cKey = 'STRING'));
*/

update treportoutvalue set cvalue = (select cvalue from tparameter where ckey = 'OUTPUT_REPORT') where cparam=4;
update treportoutvalue set cvalue='ReporteSemanal.pdf' where cid=17;
		
/*
INSERT INTO tReportOutParam (cType, cKey, cName) VALUES(1, 'JASPER_FILE', 'Archivo de iReport');
INSERT INTO tReportOutValue (cParam, cReport, cValue)
	SELECT (SELECT cId FROM tReportOutParam WHERE cKey = 'JASPER_FILE'), cId, cJasperFile FROM tReport;

ALTER TABLE tReport DROP cJasperFile;

DROP INDEX cKey_2 ON tReportOutParam;
ALTER TABLE tReportOutParam CHANGE COLUMN cType cReportType BIGINT(20) NOT NULL;

ALTER TABLE tReportParamType ADD cHTMLFile VARCHAR(50) NOT NULL AFTER cName;

UPDATE tReportType SET cJavaClass='cl.buildersoft.timectrl.business.services.impl.FileReportImpl' WHERE cKey='FILE';
*/