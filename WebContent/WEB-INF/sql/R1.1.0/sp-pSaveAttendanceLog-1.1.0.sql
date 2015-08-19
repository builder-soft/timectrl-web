DROP PROCEDURE IF EXISTS pSaveAttendanceLog;

DELIMITER $$

CREATE PROCEDURE pSaveAttendanceLog(	IN vEmployeeKey VARCHAR(15), 
										IN vMachine BIGINT(20), 
										IN vMarkType BIGINT(20),
										IN vYear INTEGER,
										IN vMonth INTEGER,
										IN vDay INTEGER,
										IN vHour INTEGER,
										IN vMinute INTEGER,
										IN vSecond INTEGER)
BEGIN
	DECLARE vDate DATETIME; # DEFAULT '0000-00-00 00:00:00';
	
#	SET vDate = DATE_FORMAT('2014-09-07 01:03:01', '%Y-%m-%d %h:%i:%s');
#	SET vDate = STR_TO_DATE('2014-09-07 00:03:01', '%Y-%m-%d %h:%i:%s');
#	SET vDate = TIMESTAMP('2014-09-07 00:03:01');
	
	#fToDateTime(vYear, vMonth, vDay, vHour, vMinute, vSecond);
	
	INSERT INTO tAttendanceLog(cEmployeeKey, cMachine, cMarkType, cDate)
	VALUES					  (vEmployeeKey, vMachine, vMarkType, vDate);

#	select * from tAttendanceLog where cid in (select max(cid) from tAttendanceLog); 
END$$

DELIMITER ;
