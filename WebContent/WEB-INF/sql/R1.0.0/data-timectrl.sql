INSERT INTO tDataType(cKey, cName) VALUES('STRING', 'String');
SET @stringId = LAST_INSERT_ID();
INSERT INTO tDataType(cKey, cName) VALUES('DOUBLE', 'Double');
SET @doubleId = LAST_INSERT_ID();
INSERT INTO tDataType(cKey, cName) VALUES('INTEGER', 'Integer');
SET @integerId = LAST_INSERT_ID();
INSERT INTO tDataType(cKey, cName) VALUES('TIMESTAMP', 'Timestamp');
SET @timestampId = LAST_INSERT_ID();
INSERT INTO tDataType(cKey, cName) VALUES('BOOLEAN', 'Boolean');
SET @booleanId = LAST_INSERT_ID();
INSERT INTO tDataType(cKey, cName) VALUES('LONG', 'Long');
SET @longId = LAST_INSERT_ID();

INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('FORMAT_DATE', 'Formato de Fecha', 'dd-MM-yyyy', @stringId);
INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('FORMAT_DATETIME', 'Formado de fecha/hora', 'dd-MM-yyyy HH:mm', @stringId);

INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('LOCALE', 'Región, afecta a formato de n&uacute;meros(ISO-639)', 'ES', @stringId);
INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('PATTERN_INTEGER', 'Formato para montos enteros', '###.###.##0', @stringId);
INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('PATTERN_DECIMAL', 'Formato para montos con decimales', '###.###.##0,00###', @stringId);

INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('CSV_SEPARATOR', 'Separador de archivos csv', ';', @stringId);
INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('RECORDS_PER_PAGE', 'Registros por p&aacute;gina', '15', @integerId);
INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('EMPLOYEE_FILES', 'Ubicaci&oacute;n de archivos de empleados (en server)', 'D:\\temp\\remcon', @stringId);
INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('EMULATE', 'Simula interfaz de reloj control', 'true', @booleanId);
#INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('LICENSE', 'Valor de licencia de software', 'EQ+Syir1ZxcbsLwA56Dqaw==', @stringId);

INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('ATTENDANCE_REPORT', 'Archivo de reporte de asistencia', 'D:\\workspace\\timectrl-web\\WebContent\\WEB-INF\\sql\\timecontrol\\reporte-horas.jasper', @stringId);
INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('WEEKLY_REPORT', 'Archivo de reporte de asistencia, semanal', 'D:\\workspace\\timectrl-web\\WebContent\\WEB-INF\\report\\weekly-main.jasper', @stringId);
INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('PLAIN_REPORT', 'Archivo de reporte plano', 'D:\\workspace\\timectrl-web\\WebContent\\WEB-INF\\sql\\timecontrol\\report1_RSA_Completo.jasper', @stringId);
INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('LATE_REPORT', 'Archivo de reporte para retrazados', 'D:\\workspace\\timectrl-web\\WebContent\\WEB-INF\\sql\\timecontrol\\rpt_RSA_Atrasos_Tabla.jasper', @stringId);
INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('OUTPUT_LATE_NAME', 'Archivo del reporte de retrazo', 'Reporte_de_atrazados.pdf', @stringId);
INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('OUTPUT_REPORT', 'Carpeta donde va a dejar los archivos de reporte', 'D:\\temp\\7\\temp\\reportes-generados', @stringId);
INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('ABSENCE_REPORT', 'Archivo de reporte para inasistencias', 'D:\\workspace\\timectrl-web\\WebContent\\WEB-INF\\sql\\timecontrol\\Inasistencas.jasper', @stringId);
INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('OUTPUT_ABSENCE_NAME', 'Archivo de inasistencias', 'Reporte_de_inasistencias.pdf', @stringId);
INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('W8COMPATIBLE', 'Compatibilidad con Windows 8', 'false', @booleanId);

INSERT INTO tRol(cName) VALUES('Administrador');
SET @rolId = LAST_INSERT_ID();

SELECT cId INTO @userId FROM bsframework.tUser WHERE cMail = 'admin';

INSERT INTO tR_UserRol(cUser, cRol) VALUES(@userId, @rolId);

/** DATOS DE PRUEBA */

INSERT INTO tPrivilege(cKey, cName) VALUES(0, 'Usuario común');
INSERT INTO tPrivilege(cKey, cName) VALUES(1, 'Enrolador');
INSERT INTO tPrivilege(cKey, cName) VALUES(2, 'Administrador');
INSERT INTO tPrivilege(cKey, cName) VALUES(3, 'Super administrador');

INSERT INTO tMarkType(cKey, cName) VALUES('1', 'Entrada');
INSERT INTO tMarkType(cKey, cName) VALUES('0','Colación');
INSERT INTO tMarkType(cKey, cName) VALUES('1','Vuelta');
INSERT INTO tMarkType(cKey, cName) VALUES('O','Salida');

INSERT INTO tFiscalDate(cDate) VALUES('2011-08-01');
INSERT INTO tFiscalDate(cDate) VALUES('2011-08-02');

INSERT INTO tFiscalDate(cDate) VALUES('2012-09-17');
INSERT INTO tFiscalDate(cDate) VALUES('2012-09-18');
INSERT INTO tFiscalDate(cDate) VALUES('2012-09-19');

INSERT INTO tFiscalDate(cDate, cReason) VALUES('2014-07-16', 'Día de la Virgen del Carmen');
INSERT INTO tFiscalDate(cDate, cReason) VALUES('2014-08-15', 'Asunción de la Virgen');
INSERT INTO tFiscalDate(cDate, cReason) VALUES('2014-09-18', 'Independencia Nacional');
INSERT INTO tFiscalDate(cDate, cReason) VALUES('2014-09-19', 'Glorias del ejercito');

/* R E P O R T E S   B A S I C O S */
INSERT INTO tReportOutType(cKey, cName) VALUES('FILE', 'Generacion de archivos');
SET @outputFileType = LAST_INSERT_ID();
INSERT INTO tReportOutType(cKey, cName) VALUES('DOWNLOAD', 'Desarga en página');
INSERT INTO tReportOutType(cKey, cName) VALUES('MAIL', 'Envio por email');

INSERT INTO tReportParamType(cKey, cName) VALUES('SQL', 'Instrucción SQL');
SET @sql = LAST_INSERT_ID();
INSERT INTO tReportParamType(cKey, cName) VALUES('DATE', 'Ingreso de fecha');
SET @date = LAST_INSERT_ID();

INSERT INTO tReportOutParam(cType, cKey, cName) VALUES(@outputFileType, 'OUTPUT_FILE', 'Nombre del archivo de salida');
SET @outputFileParam = LAST_INSERT_ID();
INSERT INTO tReportOutParam(cType, cKey, cName) VALUES(@outputFileType, 'FORMAT', 'Formato de salida (pdf o xls)');
SET @outputFormatParam = LAST_INSERT_ID();
INSERT INTO tReportOutParam(cType, cKey, cName) VALUES(@outputFileType, 'SEPARATED', 'Separado por area + fecha');
SET @outputSeparatedParam = LAST_INSERT_ID();

/*-----------------------------------------------------*/
INSERT INTO tReport(cName, cJasperFile, cOutType) VALUES('Reporte de asistencia', 'reporte-horas.jasper', @outputFileType);
SET @reportId = LAST_INSERT_ID();
INSERT INTO tReportOutValue(cParam, cType, cReport, cValue) VALUES(@outputFileParam, @outputFileType, @reportId, 'reporte-${EmployeeKey}');
INSERT INTO tReportOutValue(cParam, cType, cReport, cValue) VALUES(@outputFormatParam, @outputFileType, @reportId, 'pdf');
INSERT INTO tReportOutValue(cParam, cType, cReport, cValue) VALUES(@outputSeparatedParam, @outputFileType, @reportId, 'true');

INSERT INTO tReportParam(cReport, cName, cType, cValue) VALUES(@reportId, 'Employee', @sql, 'call ListEmployee()');
INSERT INTO tReportParam(cReport, cName, cType, cValue) VALUES(@reportId, 'StartDate', @date, '');
INSERT INTO tReportParam(cReport, cName, cType, cValue) VALUES(@reportId, 'EndDate', @date, '');

/*-----------------------------------------------------*/
INSERT INTO tReport(cName, cJasperFile, cOutType) VALUES('Reporte de retrazos', 'rpt_RSA_Atrasos_Tabla.jasper', @outputFileType);
SET @reportId = LAST_INSERT_ID();
INSERT INTO tReportOutValue(cParam, cType, cReport, cValue) VALUES(@outputFileParam, @outputFileType, @reportId, 'Reporte_de_atrazados.pdf');
INSERT INTO tReportOutValue(cParam, cType, cReport, cValue) VALUES(@outputFormatParam, @outputFileType, @reportId, 'pdf');
INSERT INTO tReportOutValue(cParam, cType, cReport, cValue) VALUES(@outputSeparatedParam, @outputFileType, @reportId, 'false');

INSERT INTO tReportParam(cReport, cName, cType, cValue) VALUES(@reportId, 'StartDate', @date, '');
INSERT INTO tReportParam(cReport, cName, cType, cValue) VALUES(@reportId, 'EndDate', @date, '');

/*-----------------------------------------------------*/
INSERT INTO tReport(cName, cJasperFile, cOutType) VALUES('Reporte de inasistencias', 'Inasistencas.jasper', @outputFileType);
SET @reportId = LAST_INSERT_ID();
INSERT INTO tReportOutValue(cParam, cType, cReport, cValue) VALUES(@outputFileParam, @outputFileType, @reportId, 'Reporte_de_inasistencias.pdf');
INSERT INTO tReportOutValue(cParam, cType, cReport, cValue) VALUES(@outputFormatParam, @outputFileType, @reportId, 'xls');
INSERT INTO tReportOutValue(cParam, cType, cReport, cValue) VALUES(@outputSeparatedParam, @outputFileType, @reportId, 'false');

INSERT INTO tReportParam(cReport, cName, cType, cValue) VALUES(@reportId, 'cAbsenceDate', @date, '');

/*-----------------------------------------------------*/
INSERT INTO tReport(cName, cJasperFile, cOutType) VALUES('Reporte Listado de asistencias', 'report1_RSA_Completo.jasper', @outputFileType);
SET @reportId = LAST_INSERT_ID();
INSERT INTO tReportOutValue(cParam, cType, cReport, cValue) VALUES(@outputFileParam, @outputFileType, @reportId, 'Reporte_completo.xls');
INSERT INTO tReportOutValue(cParam, cType, cReport, cValue) VALUES(@outputFormatParam, @outputFileType, @reportId, 'xls');
INSERT INTO tReportOutValue(cParam, cType, cReport, cValue) VALUES(@outputSeparatedParam, @outputFileType, @reportId, 'false');

INSERT INTO tReportParam(cReport, cName, cType, cValue) VALUES(@reportId, 'StartDate', @date, '');
INSERT INTO tReportParam(cReport, cName, cType, cValue) VALUES(@reportId, 'EndDate', @date, '');
/* R E P O R T E S   B A S I C O S */ 

