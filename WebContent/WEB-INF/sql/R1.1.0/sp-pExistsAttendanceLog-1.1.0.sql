DROP PROCEDURE IF EXISTS pExistsAttendanceLog;

DELIMITER $$

/** Inicio */
CREATE PROCEDURE pExistsAttendanceLog(	IN vEmployeeKey VARCHAR(15), 
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
	SET vDate = fToDateTime(vYear, vMonth, vDay, vHour, vMinute, vSecond);
	
	SELECT	count(cId) 
	FROM	tAttendanceLog 
	WHERE	cEmployeeKey=vEmployeeKey AND 
			cMachine=vMachine AND 
			cMarkType=vMarkType	AND 
			cDate=vDate;

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
	SET vOut = CONCAT(CONCAT_WS('-', vYear, vMonth, vDay), ' ', CONCAT_WS(':', vHour, vMinute, vSecond));
	RETURN vOut;	
END$$

DELIMITER ;
