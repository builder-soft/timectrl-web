DROP PROCEDURE IF EXISTS pSaveAttendanceLog2;

DELIMITER $$

CREATE PROCEDURE pSaveAttendanceLog2(	IN vEmployeeKey VARCHAR(15), 
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
	DECLARE vCount	INTEGER;
	
	SET vDate = fToDateTime(vYear, vMonth, vDay, vHour, vMinute, vSecond);
	
	SELECT	count(cId) INTO vCount 
	FROM	tAttendanceLog 
	WHERE	cEmployeeKey=vEmployeeKey AND 
			cMachine=vMachine AND 
			cMarkType=vMarkType	AND 
			cDate=vDate;
	
	IF(vCount=0) THEN
		INSERT INTO tAttendanceLog(cEmployeeKey, cMachine, cMarkType, cDate)
		VALUES					  (vEmployeeKey, vMachine, vMarkType, vDate);
		SELECT 1;
	ELSE
		SELECT 0;
	END IF;
	
END$$