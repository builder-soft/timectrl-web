ALTER TABLE tAttendanceLog ADD COLUMN cHash CHAR(32) COMMENT 'Hash del registro' AFTER cMarkType;
UPDATE tAttendanceLog SET cHash=md5(concat(cId, "#", cEmployeeKey, "#",cMachine, "#",cDate, "#",cMarkType)); 

DROP TRIGER InsertOnAttendanceLog;
CREATE TRIGGER InsertOnAttendanceLog AFTER INSERT ON tAttendanceLog
FOR EACH ROW
BEGIN
	
/* 
	INSERT INTO tAttendanceLog(cEnterprise, cTextFootSalary) 
	VALUES (NEW.cId, '');
	*/
END$$

