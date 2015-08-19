ALTER TABLE tArea CHANGE COLUMN cCostCenter cCostCenter VARCHAR(10) NOT NULL;

ALTER TABLE tReportPropertyType CHANGE COLUMN cKey cKey VARCHAR(20) NOT NULL UNIQUE;

update tReportType SET cJavaClass='cl.buildersoft.timectrl.business.services.impl.ListToXExcelImpl' WHERE cKey = 'PLAIN_EXCEL'; 

DROP PROCEDURE if exists pUpdateData;
DELIMITER $$

CREATE PROCEDURE pUpdateData()
BEGIN
	DECLARE vBG_COLOR_HEAD BIGINT(20);
	DECLARE vFONT_COLOR_HEAD BIGINT(20);
	DECLARE vBG_COLOR_CELL BIGINT(20);
	DECLARE vFONT_COLOR_CELL BIGINT(20);
	DECLARE vFONT_NAME BIGINT(20);
	DECLARE vFONT_SIZE BIGINT(20);
	DECLARE vReportExcel BIGINT(20);
	
	DECLARE vReport1 BIGINT(20);
	DECLARE vReport2 BIGINT(20);
	DECLARE vReport3 BIGINT(20);
	
	insert into tReportPropertyType(cKey, cName) VALUES('BG_COLOR_HEAD', 'Color de fondo en cabecera');
	SET vBG_COLOR_HEAD=LAST_INSERT_ID();
	insert into tReportPropertyType(cKey, cName) VALUES('FONT_COLOR_HEAD', 'Color de letra en cabecera');
	SET vFONT_COLOR_HEAD=LAST_INSERT_ID();
	insert into tReportPropertyType(cKey, cName) VALUES('BG_COLOR_CELL', 'Color de fondo en el contenido');
	SET vBG_COLOR_CELL=LAST_INSERT_ID();
	insert into tReportPropertyType(cKey, cName) VALUES('FONT_COLOR_CELL', 'Color de letra en contenido');
	SET vFONT_COLOR_CELL=LAST_INSERT_ID();
	insert into tReportPropertyType(cKey, cName) VALUES('FONT_NAME', 'Tipo de Letra');
	SET vFONT_NAME=LAST_INSERT_ID();
	insert into tReportPropertyType(cKey, cName) VALUES('FONT_SIZE', 'Tamaño de letra');
	SET vFONT_SIZE=LAST_INSERT_ID();
	
	SELECT cId INTO vReportExcel FROM tReportType WHERE cKey='PLAIN_EXCEL';
	
	insert into tR_ReportPropertyType_ReportType(cReportType, cReportPropertyType) VALUES(vReportExcel, vBG_COLOR_HEAD);
	insert into tR_ReportPropertyType_ReportType(cReportType, cReportPropertyType) VALUES(vReportExcel, vFONT_COLOR_HEAD);
	insert into tR_ReportPropertyType_ReportType(cReportType, cReportPropertyType) VALUES(vReportExcel, vBG_COLOR_CELL);
	insert into tR_ReportPropertyType_ReportType(cReportType, cReportPropertyType) VALUES(vReportExcel, vFONT_COLOR_CELL);
	insert into tR_ReportPropertyType_ReportType(cReportType, cReportPropertyType) VALUES(vReportExcel, vFONT_NAME);
	insert into tR_ReportPropertyType_ReportType(cReportType, cReportPropertyType) VALUES(vReportExcel, vFONT_SIZE);

	SELECT cId INTO vReport1 FROM tReport WHERE cKey='PLAIN_EXCEL';
	SELECT cId INTO vReport2 FROM tReport WHERE cKey='ABSENCE';
	SELECT cId INTO vReport3 FROM tReport WHERE cKey='LATER';
	
	
	insert into tReportProperty(cPropertyType, cReport, cValue) VALUES(vBG_COLOR_HEAD,		vReport1, '#190033');
	insert into tReportProperty(cPropertyType, cReport, cValue) VALUES(vFONT_COLOR_HEAD,	vReport1, '#E0E0E0');
	insert into tReportProperty(cPropertyType, cReport, cValue) VALUES(vBG_COLOR_CELL,		vReport1, '#FFFF99');
	insert into tReportProperty(cPropertyType, cReport, cValue) VALUES(vFONT_COLOR_CELL,	vReport1, '#660000');
	insert into tReportProperty(cPropertyType, cReport, cValue) VALUES(vFONT_NAME,			vReport1, 'Trebuchet MS');
	insert into tReportProperty(cPropertyType, cReport, cValue) VALUES(vFONT_SIZE,			vReport1, '10');

	insert into tReportProperty(cPropertyType, cReport, cValue) VALUES(vBG_COLOR_HEAD,		vReport2, '#190033');
	insert into tReportProperty(cPropertyType, cReport, cValue) VALUES(vFONT_COLOR_HEAD,	vReport2, '#E0E0E0');
	insert into tReportProperty(cPropertyType, cReport, cValue) VALUES(vBG_COLOR_CELL,		vReport2, '#FFFF99');
	insert into tReportProperty(cPropertyType, cReport, cValue) VALUES(vFONT_COLOR_CELL,	vReport2, '#660000');
	insert into tReportProperty(cPropertyType, cReport, cValue) VALUES(vFONT_NAME,			vReport2, 'Trebuchet MS');
	insert into tReportProperty(cPropertyType, cReport, cValue) VALUES(vFONT_SIZE,			vReport2, '10');

	insert into tReportProperty(cPropertyType, cReport, cValue) VALUES(vBG_COLOR_HEAD,		vReport3, '#190033');
	insert into tReportProperty(cPropertyType, cReport, cValue) VALUES(vFONT_COLOR_HEAD,	vReport3, '#E0E0E0');
	insert into tReportProperty(cPropertyType, cReport, cValue) VALUES(vBG_COLOR_CELL,		vReport3, '#FFFF99');
	insert into tReportProperty(cPropertyType, cReport, cValue) VALUES(vFONT_COLOR_CELL,	vReport3, '#660000');
	insert into tReportProperty(cPropertyType, cReport, cValue) VALUES(vFONT_NAME,			vReport3, 'Trebuchet MS');
	insert into tReportProperty(cPropertyType, cReport, cValue) VALUES(vFONT_SIZE,			vReport3, '10');
	
	
END$$

DELIMITER ;

call pUpdateData();

DROP PROCEDURE if exists pUpdateData;

#------------------ Creacion de relacion entre empleado y reloj ------------------

create table tGroup (
	cId 				BIGINT(20) NOT NULL auto_increment,
	cKey				VARCHAR(10) NOT NULL UNIQUE,
	cName				VARCHAR(50) NOT NULL,
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

ALTER TABLE tEmployee ADD cGroup BIGINT(20) NOT NULL AFTER cEnabled;
ALTER TABLE tMachine ADD cGroup BIGINT(20) NOT NULL AFTER cSerial;

INSERT INTO tGroup(cKey, cName) VALUES('MAIN', 'Principal');
SET @GroupId = LAST_INSERT_ID();

UPDATE tEmployee SET cGroup = @GroupId;
UPDATE tMachine SET cGroup = @GroupId;

ALTER TABLE tEmployee
ADD INDEX employee_index_group (cGroup ASC),
ADD CONSTRAINT EmployeeToGroup FOREIGN KEY (cGroup) REFERENCES tGroup(cId);

ALTER TABLE tMachine
ADD INDEX machine_index_group (cGroup ASC),
ADD CONSTRAINT MachineToGroup FOREIGN KEY (cGroup) REFERENCES tGroup(cId);

delete from tMarktype where cid>=7;

ALTER TABLE tPrivilege CHANGE COLUMN cKey cKey INTEGER NOT NULL UNIQUE;
ALTER TABLE tArea CHANGE COLUMN cKey cKey VARCHAR(10) NOT NULL DEFAULT '' UNIQUE;
ALTER TABLE tEmployee CHANGE COLUMN cKey cKey VARCHAR(25) NOT NULL UNIQUE;
ALTER TABLE tMarktype CHANGE COLUMN cKey cKey VARCHAR(1) NOT NULL UNIQUE;
ALTER TABLE tPost CHANGE COLUMN cKey cKey VARCHAR(10) NOT NULL UNIQUE;

#----------- Creacion de opcion para mantenedor de grupos -----------
INSERT INTO tOption (cKey, cLabel, cUrl, cParent, cType, cOrder) VALUES('GROUP_MGR', 'Grupos', '/servlet/timectrl/group/GroupManager', 9, 1, 7);

#----------- Envio de reportes por mail -----------

ALTER TABLE tReportPropertyType CHANGE COLUMN cKey cKey VARCHAR(30) NOT NULL UNIQUE;
ALTER TABLE tReportPropertyType CHANGE COLUMN cName cName VARCHAR(100) NOT NULL DEFAULT '';

INSERT INTO tReportType(cKey, cName, cJavaClass) VALUES('SEND_BY_MAIL', 'Envio reporte por correo', 'cl.buildersoft.timectrl.business.services.impl.SendReportByMailImpl');
SET @newReportType=LAST_INSERT_ID();
# INSERT INTO tReport(cKey, cName, cType) VALUES('SEND_BY_MAIL1', 'Envio de reporte por correo', LAST_INSERT_ID());

INSERT INTO tReportPropertyType(cKey,cName) VALUES('SUB_REPORT', 'Sub-Reporte (Reporte a enviar)');
INSERT INTO tR_ReportPropertyType_ReportType(cReportType, cReportPropertyType) VALUES(@newReportType, LAST_INSERT_ID());

INSERT INTO tReportPropertyType(cKey,cName) VALUES('mail.smtp.host', 'Servidor de correo (smtp.gmail.com)');
INSERT INTO tR_ReportPropertyType_ReportType(cReportType, cReportPropertyType) VALUES(@newReportType, LAST_INSERT_ID());

INSERT INTO tReportPropertyType(cKey,cName) VALUES('mail.smtp.port', 'Puerto del servidor (587)');
INSERT INTO tR_ReportPropertyType_ReportType(cReportType, cReportPropertyType) VALUES(@newReportType, LAST_INSERT_ID());

INSERT INTO tReportPropertyType(cKey,cName) VALUES('mail.smtp.starttls.enable', 'Habilitacion de TLS [true|false] default:true');
INSERT INTO tR_ReportPropertyType_ReportType(cReportType, cReportPropertyType) VALUES(@newReportType, LAST_INSERT_ID());

INSERT INTO tReportPropertyType(cKey,cName) VALUES('mail.smtp.auth', 'Usa autenticacion [true|false] default:true');
INSERT INTO tR_ReportPropertyType_ReportType(cReportType, cReportPropertyType) VALUES(@newReportType, LAST_INSERT_ID());

INSERT INTO tReportPropertyType(cKey,cName) VALUES('mail.smtp.user', 'Usuario de correo');
INSERT INTO tR_ReportPropertyType_ReportType(cReportType, cReportPropertyType) VALUES(@newReportType, LAST_INSERT_ID());

INSERT INTO tReportPropertyType(cKey,cName) VALUES('mail.smtp.password', 'Clave de correo');
INSERT INTO tR_ReportPropertyType_ReportType(cReportType, cReportPropertyType) VALUES(@newReportType, LAST_INSERT_ID());

INSERT INTO tReportPropertyType(cKey,cName) VALUES('SUBJECT', 'Asunto');
INSERT INTO tR_ReportPropertyType_ReportType(cReportType, cReportPropertyType) VALUES(@newReportType, LAST_INSERT_ID());

INSERT INTO tReportPropertyType(cKey,cName) VALUES('TEXT', 'Texto del mensaje');
INSERT INTO tR_ReportPropertyType_ReportType(cReportType, cReportPropertyType) VALUES(@newReportType, LAST_INSERT_ID());

INSERT INTO tReportPropertyType(cKey,cName) VALUES('DESTINY', 'Destinatario del correo [MANPOWER, EACH_ONE]');
INSERT INTO tR_ReportPropertyType_ReportType(cReportType, cReportPropertyType) VALUES(@newReportType, LAST_INSERT_ID());

INSERT INTO tReportPropertyType(cKey,cName) VALUES('MANPOWER_MAIL', 'Casilla de correo de Recursos Humanos');
INSERT INTO tR_ReportPropertyType_ReportType(cReportType, cReportPropertyType) VALUES(@newReportType, LAST_INSERT_ID());

UPDATE tReportParamType SET cKey='EMPLOYEE_LIST' WHERE cKey='CUSTOMER_LIST';

ALTER TABLE tEmployee ADD cMail VARCHAR(50) NULL AFTER cUsername;

ALTER TABLE tEmployee ADD cBoss BIGINT(20) NULL AFTER cMail;
ALTER TABLE tEmployee
ADD INDEX employee_index_employee (cBoss ASC),
ADD CONSTRAINT EmployeeToEmployee FOREIGN KEY (cBoss) REFERENCES tEmployee(cId);

UPDATE tEmployee SET cMail = '' WHERE cMail IS null;

