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
	DECLARE vDate DATETIME;
	
#	SET vDate = DATE_FORMAT('2014-09-07 01:03:01', '%Y-%m-%d %h:%i:%s');
#	SET vDate = STR_TO_DATE('2014-09-07 00:03:01', '%Y-%m-%d %h:%i:%s');
#	SET vDate = TIMESTAMP('2014-09-07 00:03:01');
	
	SET vDate = fToDateTime(vYear, vMonth, vDay, vHour, vMinute, vSecond);
	
	INSERT INTO tAttendanceLog(cEmployeeKey, cMachine, cMarkType, cDate)
	VALUES					  (vEmployeeKey, vMachine, vMarkType, vDate);

#	select vDate;
#	select * from tAttendanceLog where cid in (select max(cid) from tAttendanceLog); 
END$$

DROP FUNCTION IF EXISTS fToDateTime;
CREATE FUNCTION fToDateTime(vYear INTEGER,
							vMonth INTEGER,
							vDay INTEGER,
							vHour INTEGER,
							vMinute INTEGER,
							vSecond INTEGER) RETURNS DATETIME
BEGIN
	DECLARE vOut DATETIME;
	SET vOut = DATE_FORMAT(
					CONCAT(CONCAT_WS('-', vYear, vMonth, vDay), ' ', CONCAT_WS(':', vHour, vMinute, vSecond)),
					'%Y-%m-%d %H:%i:%s'
					);
	RETURN vOut;	
END$$

DELIMITER ;
