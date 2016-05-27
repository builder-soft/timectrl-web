ALTER TABLE tAttendanceLog CHANGE COLUMN cDate cDate timestamp NULL DEFAULT NULL;
ALTER TABLE tAttendanceLog ADD COLUMN cHash CHAR(32) COMMENT 'Hash del registro' AFTER cMarkType;
UPDATE tAttendanceLog SET cHash=fGetHash(cEmployeeKey, cMachine, cDate, cMarkType); 

DROP TRIGGER if exists InsertOnAttendanceLog;
CREATE TRIGGER InsertOnAttendanceLog before INSERT ON tAttendanceLog
FOR EACH ROW
	SET NEW.cHash=fGetHash(NEW.cEmployeeKey, NEW.cMachine, NEW.cDate, NEW.cMarkType);
