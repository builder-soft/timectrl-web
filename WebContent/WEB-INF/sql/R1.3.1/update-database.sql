ALTER TABLE tAttendanceLog CHANGE COLUMN cDate cDate timestamp NULL DEFAULT NULL;
ALTER TABLE tAttendanceLog ADD COLUMN cHash CHAR(32) COMMENT 'Hash del registro' AFTER cMarkType;
UPDATE tAttendanceLog SET cHash=fGetHash(cEmployeeKey, cMachine, cDate, cMarkType); 

DROP TRIGGER if exists InsertOnAttendanceLog;
CREATE TRIGGER InsertOnAttendanceLog before INSERT ON tAttendanceLog
FOR EACH ROW
	SET NEW.cHash=fGetHash(NEW.cEmployeeKey, NEW.cMachine, NEW.cDate, NEW.cMarkType);

DROP VIEW IF EXISTS bsframework.vUser;
DROP VIEW IF EXISTS vUser;
CREATE VIEW bsframework.vUser
AS
		SELECT		a.cId, a.cMail, a.cName 
		FROM 		bsframework.tUser AS a
		LEFT JOIN	bsframework.tR_UserDomain AS b ON a.cId = b.cUser
		LEFT JOIN	bsframework.tDomain AS c ON b.cDomain = c.cId 
		WHERE		!a.cAdmin AND c.cDatabase = DATABASE();

drop procedure if exists pUpdateData_Temp;

DELIMITER $$

create procedure pUpdateData_Temp()
begin
	DECLARE RolId BIGINT(20);

	INSERT INTO tRol(cName, cDeleted) VALUES('Empleador', false);
	SET @RolId = LAST_INSERT_ID();
	
	insert into tr_roloption(cRol, cOption) 
		select @RolId, cid from toption where cContext IN ('DALEA_CONTEXT', 'TIMECTRL_CONTEXT') or cContext is null;
	
	INSERT INTO tRol(cName, cDeleted) VALUES('Fiscalizador', false);
	SET @RolId = LAST_INSERT_ID();
	
	insert into tr_roloption(cRol, cOption) 
		select @RolId, cid from toption where cKey IN ('FILES', 'ENTERPRISE', 'AREA', 'POST',
							'EMPLOYEE', 'EMPLOYEE_DATA', 'EMPLOYEE_LICENSE', 'EMPLOYEE_TURN', 'EMPLOYEE_MARK',
							'CONFIG', 'SECURITY', 'USER', 'ROL','ALLOW','REPORT','EVENT_VIEWER','EXECUTE_REPORT');
	
END$$

DELIMITER ;

call pUpdateData_Temp;
drop procedure if exists pUpdateData_Temp;

update tEventType SET cName='Nuevo turno' where cKey='INSERT_TURN';

UPDATE tVersion SET cVersion='1.3.1', cUpdated=NOW() WHERE cKey = 'DBT';
