INSERT INTO tReportOutParam (cType, cKey, cName) VALUES(1, 'JASPER_FILE', 'Archivo de iReport');
INSERT INTO tReportOutValue (cParam, cReport, cValue)
	SELECT (SELECT cId FROM tReportOutParam WHERE cKey = 'JASPER_FILE'), cId, cJasperFile FROM tReport;

ALTER TABLE tReport DROP cJasperFile;

DROP INDEX cKey_2 ON tReportOutParam;
ALTER TABLE tReportOutParam CHANGE COLUMN cType cReportType BIGINT(20) NOT NULL;

ALTER TABLE tReportParamType ADD cHTMLFile VARCHAR(50) NOT NULL AFTER cName;

UPDATE tReportType SET cJavaClass='cl.buildersoft.timectrl.business.services.impl.FileReportImpl' WHERE cKey='FILE';

UPDATE tOption SET cEnable=true WHERE cKey = 'REP_CONFIG';
INSERT INTO tReportOutParam(cReportType, cKey, cName) VALUES(1, 'SP', 'Nombre del Procedimiento almacenado a ejecutar');

INSERT INTO tReportOutValue(cParam, cReport, cValue) VALUES((SELECT cId FROM tReportOutParam WHERE cKey='SP'), 1, 'pListAttendance3');

create table tReportPropertyType (
	cId 				BIGINT(20) NOT NULL auto_increment,
	cKey				VARCHAR(20) NOT NULL,
	cName				VARCHAR(50) NOT NULL,
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

create table tReportProperty (
	cId 				BIGINT(20) NOT NULL auto_increment,
	cPropertyType		BIGINT(20) NOT NULL,
	cReport				BIGINT(20) NOT NULL,
	cValue				VARCHAR(255) NOT NULL,
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

ALTER TABLE tReportProperty
ADD INDEX reportProperty_index_reportPropertyType (cPropertyType ASC),
ADD INDEX reportProperty_index_Report (cReport ASC),
ADD CONSTRAINT ReportPropertyToReportPropertyType FOREIGN KEY (cPropertyType) REFERENCES tReportPropertyType(cId),
ADD CONSTRAINT ReportPropertyToReport FOREIGN KEY (cReport) REFERENCES tReport(cId);

insert into tReportPropertyType(cKey, cName)
	select distinct(b.cKey), b.cName from treportoutvalue as a left join treportoutparam as b on b.cid = a.cparam;

insert into tReportProperty (cPropertyType, cReport, cValue)
	select (select cid from tReportPropertyType where ckey=b.ckey), a.creport, a.cvalue from treportoutvalue as a left join treportoutparam as b on b.cid = a.cparam;

drop table if exists tReportOutValue;
drop table if exists tReportOutParam;

insert into tReportProperty(cPropertyType, cReport, cValue)
	values((select cid from tReportPropertyType where ckey='OUTPUT_FOLDER'),1, 'D:\\ReportesAsistencia');


	
insert into tReportPropertyType(cKey, cName) Values('JASPER_FOLDER', 'Carpeta donde esta el archivo jasper');
insert into tReportProperty(cPropertyType, cReport, cValue)
	values((select cid from tReportPropertyType where ckey='JASPER_FOLDER'),1, 'D:\\workspace\\timectrl-web\\WebContent\\WEB-INF\\report\\Enlasa');

	
	
update tReportPropertyType set ckey='JASPER_PATH' WHERE ckey='JASPER_FOLDER';
update tReportPropertyType set ckey='OUTPUT_PATH' WHERE ckey='OUTPUT_FOLDER';

update tReportProperty set cValue='rpt_AsistenciaPDF_v2.jasper' WHERE cPropertyType=5 AND cReport=1;
# reporte-${EmployeeKey}

delete from tReportProperty where cid=29;
delete from tReportPropertyType where cid=6;


insert into tReportPropertyType(cKey, cName) Values('SP', 'Nombre del SP a ejecutar');
insert into tReportProperty(cPropertyType, cReport, cValue)
	values((select cid from tReportPropertyType where ckey='SP'),5, 'pListAttendanceAsExcel3');

insert into tReportProperty(cPropertyType, cReport, cValue)
	values((select cid from tReportPropertyType where ckey='SP'),6, 'pAbsence');

insert into tReportProperty(cPropertyType, cReport, cValue)
	values((select cid from tReportPropertyType where ckey='SP'),8, 'pListLater');
	
ALTER TABLE treportinparam DROP cValue;
ALTER TABLE treportinparam DROP cFromUser;

update treportinparam set cOrder = cId where cOrder IS NULL;

ALTER TABLE treportparamtype ADD cSource VARCHAR(20) NULL AFTER cHTMLFile;
ALTER TABLE tReportParamType ADD cJavaType VARCHAR(10) NULL AFTER cSource;

UPDATE tReportParamType 
SET cKey='CUSTOMER_LIST', cName='Lista de empleados', cHTMLFile='CustomerList.jsp', cSource='pListEmployee', cJavaType='LONG' 
WHERE cId=1;

UPDATE tReportParamType 
SET cHTMLFile='InputDate.jsp', cSource='', cJavaType='DATE' 
WHERE cId=2;

update treportproperty set cvalue='r-{Date}_{Year}_{Month}_{EmployeeKey}_{EmployeeRut}.pdf' where cid=1;

update treportinparam set cLabel = 'Empleado' where cid=1;
 
#----------Configuracion del reporte plano en excel.---------
update treportproperty set cvalue='D:\\ReportesAsistencia\\{CostCenter}\\{Year}\\{Month}' where cid=32;
update treport set ckey='PLAIN_EXCEL' where cid=5;
update treporttype set cjavaclass='cl.buildersoft.timectrl.business.services.impl.ListToExcelImpl' where cid=4;

delete from treportinparam where cid = 11;
delete from treportproperty  where cid=25;

#----------Configuracion de otros reportes.---------
delete from treporttype  where cid in (2,3);

delete from tReportInParam where cReport in (2,3,4);
delete from treportproperty  where cReport in (2,3,4);
delete from treport  where cid in (2,3,4);

update treport set cKey = 'ABSENCE' where cid=6;
delete from tReportInParam where cId in (13);
update treportinparam set ctype=1 where cid=14;
delete from tReportParamtype where cId in (5);

update treportinparam set ctype=1 where cid=14;
update treportparamtype set ckey='MONTH', cname='Meses', cHTMLFile='Month.jsp', cSource='pListMonth', cJavaType='INTEGER'   where cid=4;
insert into treportparamtype(cKey, cName, cHTMLFile, cSource, cjavaType) values('YEAR', 'Año', 'Year.jsp', null, 'INTEGER');
update treportinparam set ctype=LAST_INSERT_ID() where cid=16;
#----------Configuracion de reporte Semanal.---------
update treportproperty set cvalue = 'Semanal-{Date}_{Year}_{Month}_{EmployeeKey}.pdf' where cid=17;
update treportproperty set cvalue = 'D:\\ReportesAsistencia\\{UserName}\\{Year}\\{Month}' where cid=18;
delete from treportproperty where cId in (3);
insert into treportproperty (cPropertyType, cReport, cValue) values(2, 7,'pdf');
insert into treportproperty (cPropertyType, cReport, cValue) values(8, 7,'D:\\workspace\\timectrl-web\\WebContent\\WEB-INF\\report');

delete from tReportInParam where cId in (19);

update treport set cName='Reporte Completo (xls)' where cid=5;

update treportparamtype set cSource=null where ckey='MONTH';
 
#----------Cambios para el manejo de turnos diferidos---------
ALTER TABLE tTurn ADD cFlexible BIT NOT NULL DEFAULT FALSE AFTER cName;

#----------Otros cambios de configuracion---------
update toption set cenable=true  where ckey = 'EXECUTE_REPORT';
 
update toption set cUrl = '/servlet/timectrl/report/execute/ReadParameters?reportId=1' where cid=20;
update toption set cUrl = '/servlet/timectrl/report/execute/ReadParameters?reportId=7' where cid=21;
update toption set cUrl = '/servlet/timectrl/report/execute/ReadParameters?reportId=5' where cid=22;
update toption set cUrl = '/servlet/timectrl/report/execute/ReadParameters?reportId=8' where cid=23;
update toption set cUrl = '/servlet/timectrl/report/execute/ReadParameters?reportId=6' where cid=24;
