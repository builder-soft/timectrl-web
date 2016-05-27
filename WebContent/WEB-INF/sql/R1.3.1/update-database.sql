ALTER TABLE tAttendanceLog ADD COLUMN cHash CHAR(32) COMMENT 'Hash del registro' AFTER cMarkType;
UPDATE tAttendanceLog SET cHash=md5(concat(cEmployeeKey, "#",cMachine, "#",cDate, "#",cMarkType)); 

DROP TRIGGER if exists InsertOnAttendanceLog;
CREATE TRIGGER InsertOnAttendanceLog before INSERT ON tAttendanceLog
FOR EACH ROW
BEGIN
#	set NEW.cHash = concat(NEW.cMachine, "#",NEW.cMarkType);
	SET NEW.cHash=md5(concat(NEW.cEmployeeKey, "#",NEW.cMachine, "#"NEW.cDate, "#",NEW.cMarkType));
/* 
	update tAttendanceLog set cHash = NEW.cId WHERE cId = NEW.cId;
	INSERT INTO tAttendanceLog(cEnterprise, cTextFootSalary) 
	VALUES (NEW.cId, '');
	*/
END;
