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

		

	
	
UPDATE tVersion SET cVersion='1.3.1', cUpdated=NOW() WHERE cKey = 'DBT';
