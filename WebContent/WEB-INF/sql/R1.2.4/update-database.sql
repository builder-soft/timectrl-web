INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('BOOTSTRAP', 'Uso de interfaz bootstrap en las pantallas que estan habilitadas para esto', 'true', (select cid from tdatatype where ckey='Boolean'));

INSERT INTO tReportType(cKey, cName, cJavaClass) VALUES('EXCEL_2', 'Excel con hoja resumen y detalle', 'cl.buildersoft.timectrl.business.services.impl.XExcel2Impl');
SET @reportType = LAST_INSERT_ID();
call pAddReportProperty('SP_SUMMARY', 'Procedimiento Almacenado que genera el detalle', @reportType, 'pListSummaryReport');
call pAddReportProperty('OUTPUT_FILE', 'Nombre del archivo de salida', @reportType, 'Jefatura_{Date}.xls');
call pAddReportProperty('OUTPUT_PATH', 'Carpeta de Salida', @reportType, 'D:\ReportesAsistencia');
call pAddReportProperty('SP', 'Nombre del SP a ejecutar con el detelle', @reportType, 'pListDetailReport');
call pAddReportProperty('BG_COLOR_HEAD', 'Color de fondo en cabecera', @reportType, '#190033');
call pAddReportProperty('FONT_COLOR_HEAD', 'Color de letra en cabecera', @reportType, '#E0E0E0');
call pAddReportProperty('BG_COLOR_CELL', 'Color de fondo en el contenido', @reportType, '#FFFF99');
call pAddReportProperty('FONT_COLOR_CELL', 'Color de letra en contenido', @reportType, '#660000');
call pAddReportProperty('FONT_NAME', 'Tipo de Letra', @reportType, 'Trebuchet MS');
call pAddReportProperty('FONT_SIZE', 'Tamaño de letra', @reportType, '10');
call pAddReportProperty('COLS_AS_TITLE', 'Cantidad Columns como titulo de la sub tabla', @reportType, '2');
call pAddReportProperty('EMPLOYEE_DEPTH', 'Profundidad de nileves de empleados a considerar (0=todos)', @reportType, '2');

UPDATE tReportParamType SET cHTMLFile='EmployeeList.jsp' WHERE cKey = 'EMPLOYEE_LIST'; 

INSERT INTO tReportParamType(cKey, cName, cHTMLFile, cSource, cJavaType) VALUES('BOSS_LIST', 'Listado de jefes', 'EmployeeList.jsp', 'pListBoss', 'LONG');

delete from treportproperty where cPropertyType=5 and creport=8;
delete from treportproperty where cPropertyType=5 and creport=6;
