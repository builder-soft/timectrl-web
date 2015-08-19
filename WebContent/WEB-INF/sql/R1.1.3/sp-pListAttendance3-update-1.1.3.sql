DROP PROCEDURE IF EXISTS pListAttendance3;

DELIMITER $$

/** Inicio */
CREATE PROCEDURE pListAttendance3(IN vEmployeeId BIGINT(20), IN vStartDate DATE, IN vEndDate DATE)
BEGIN
	DECLARE vCurrent	DATE;
	DECLARE vStartTime	VARCHAR(8);
	DECLARE vStartMark	TIMESTAMP;
	DECLARE vStartDiffI	INTEGER;
	DECLARE vStartDiffM	VARCHAR(9);
	
	DECLARE vLunchMark	VARCHAR(8);
	DECLARE vReturnMark	VARCHAR(8);
	
	DECLARE vEndTime	VARCHAR(8);
	DECLARE vEndMark	TIMESTAMP;
	DECLARE vEndDiffI	INTEGER;
	DECLARE vEndDiffM	VARCHAR(9);
	
	DECLARE vComment	VARCHAR(120) DEFAULT '';
	DECLARE vMachine	BIGINT(20);
	
/**Variables locales */	
	DECLARE vTurnDayId	BIGINT(20);
	DECLARE vEmployeeKey	VARCHAR(20);
	DECLARE vRUT		VARCHAR(12);
	DECLARE vMins		INTEGER;
	
	DECLARE vUpperLimit		DATETIME;
	DECLARE vLowerLimit		DATETIME;
	
	DECLARE vTolerance		INTEGER;
	
	SET vTolerance = fGetTolerance();
	
	DROP TEMPORARY TABLE IF EXISTS tAttendance_temp;
	CREATE TEMPORARY TABLE tAttendance_temp(
		cId			BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		cDate		DATE NOT NULL,
		
		cStartTime	VARCHAR(8),
		cStartMark	VARCHAR(90),
		cStartDiffI	INTEGER,
		cStartDiffM	VARCHAR(9),
		
		cLunchMark	VARCHAR(8),
		cReturnMark	VARCHAR(8),
		
		cEndTime	VARCHAR(8),
		cEndMark	VARCHAR(90),
		cEndDiffI	INTEGER,
		cEndDiffM	VARCHAR(9),
		
		cComment	VARCHAR(120),
		cMachine	BIGINT(20)		
    ) Engine=memory;
	
    SET vCurrent = vStartDate;
    SET vEndDate = DATE_ADD(vEndDate, INTERVAL 1 DAY);
    
	SELECT cKey, cRUT INTO vEmployeeKey, vRUT 
	FROM tEmployee 
	WHERE cId = vEmployeeId;
	
	WHILE vCurrent != vEndDate DO
		SET vTurnDayId = fMarkAndUserToTurnDayId3(vCurrent, vEmployeeId);
		
		IF(vTurnDayId IS NULL) THEN
			SET vStartMark = (SELECT cDate FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=1 ORDER BY cDate LIMIT 1);
			SET vStartTime = fInferTime(vStartMark);
			IF (vStartTime = '00:00:00') THEN
				SET vUpperLimit = fToDateTime(YEAR(vCurrent), MONTH(vCurrent), DAY(vCurrent), 0,0,0);
				SET vLowerLimit = fToDateTime(YEAR(vCurrent), MONTH(vCurrent), DAY(vCurrent), 0,0,0);
				SET vUpperLimit = TIMESTAMPADD(MINUTE, vTolerance * -1, vUpperLimit);
				SET vLowerLimit = TIMESTAMPADD(MINUTE, vTolerance, vLowerLimit);
				
				SET vStartMark = (	SELECT cDate 
									FROM tAttendanceLog 
									WHERE cEmployeeKey = vEmployeeKey AND 
										cDate BETWEEN vUpperLimit AND vLowerLimit AND 
										cMarkType=1 
									ORDER BY cDate LIMIT 1);
			END IF;
		ELSE
			SET vStartTime = (SELECT cStartTime FROM tTurnDay WHERE cId = vTurnDayId);
			SET vStartMark = fGetRealMark3(vEmployeeKey, vCurrent, fGetTolerance(), vStartTime);
		END IF;

		SET vStartDiffI = fExtraTimeAsMins3(vStartMark, vStartTime, TRUE);
		SET vStartDiffM = fExtraTime3(vStartDiffI);
		
		SET vLunchMark = (SELECT TIME(cDate) FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=2 LIMIT 1);
		SET vReturnMark = (SELECT TIME(cDate) FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=3 LIMIT 1);
		
		IF(vTurnDayId IS NULL) THEN
			SET vEndMark = (SELECT cDate FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=4 ORDER BY cDate DESC LIMIT 1);
			SET vEndTime = fInferTime(vEndMark);
			IF (vEndTime = '00:00:00') THEN
				SET vUpperLimit = fToDateTime(YEAR(vCurrent), MONTH(vCurrent), DAY(vCurrent), 0,0,0);
				SET vLowerLimit = fToDateTime(YEAR(vCurrent), MONTH(vCurrent), DAY(vCurrent), 0,0,0);
				SET vUpperLimit = TIMESTAMPADD(MINUTE, vTolerance * -1, vUpperLimit);
				SET vLowerLimit = TIMESTAMPADD(MINUTE, vTolerance, vLowerLimit);
				
				SET vEndMark = (	SELECT cDate 
									FROM tAttendanceLog 
									WHERE cEmployeeKey = vEmployeeKey AND 
										cDate BETWEEN vUpperLimit AND vLowerLimit AND 
										cMarkType=4 
									ORDER BY cDate DESC LIMIT 1);
			END IF;
			
		ELSE
			SET vEndTime = (SELECT cEndTime FROM tTurnDay WHERE cId = vTurnDayId);
			SET vEndMark = (SELECT cDate FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=4 ORDER BY cDate DESC LIMIT 1);
		END IF;
		
		SET vEndDiffI = fExtraTimeAsMins3(vEndMark, vEndTime, FALSE);
		SET vEndDiffM = fExtraTime3(vEndDiffI);

		SET vMins = fExtraTimeAsMins3(vStartMark, vStartTime, TRUE);
		
		SET vMachine = (SELECT cMachine FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=1 LIMIT 1);
		
		SET vComment = fGetComment3(vCurrent, vEmployeeId);
		IF(vTurnDayId IS NULL) THEN
			SET vComment = CONCAT(vComment, 'Turno diferido'); 
		END IF;
		
		INSERT INTO tAttendance_temp
				(cDate   , cStartTime, cStartMark, cStartDiffI, cStartDiffM, 
				cLunchMark, cReturnMark, 
				cEndTime, cEndMark, cEndDiffI, cEndDiffM,
				cMachine, cComment)
		VALUES	(vCurrent, vStartTime, TIME(vStartMark), vStartDiffI, vStartDiffM,			 
				vLunchMark, vReturnMark, 
				vEndTime, TIME(vEndMark), vEndDiffI, vEndDiffM,
				vMachine, vComment);
		
		SET vCurrent = DATE_ADD(vCurrent, INTERVAL 1 DAY);
	END WHILE;
	
	SELECT  cId, cDate, IFNULL(cStartTime,'') AS cStartTime, IFNULL(cStartMark,'') AS cStartMark, IFNULL(cStartDiffI, '') AS cStartDiffI, 
			IFNULL(cStartDiffM, '') AS cStartDiffM, IFNULL(cLunchMark, '') AS cLunchMark, IFNULL(cReturnMark, '') AS cReturnMark, IFNULL(cEndTime, '') AS cEndTime, IFNULL(cEndMark, '') AS cEndMark, 
			IFNULL(cEndDiffI,'') AS cEndDiffI, IFNULL(cEndDiffM,'') AS cEndDiffM, cComment, IFNULL(cMachine,'') AS cMachine,
			fDayOfWeek3(cDate) AS cDayOfWeek, vRUT AS cRUT /* Este campo debe desaparecer */ 
	FROM tAttendance_temp;
	
	DROP TEMPORARY TABLE tAttendance_temp;
END$$

DROP FUNCTION IF EXISTS fInferTime;
CREATE FUNCTION fInferTime(vMarkTime DATETIME) RETURNS CHAR(8)
BEGIN
	DECLARE vOut CHAR(10) DEFAULT '';
/**
		Administrativo 8:00 a 18:00
		Turno Mañana 8:00 a 16:00
		Turno Tarde 16:00 a 24:00
		Turno Noche 24:00 a 08:00
*/
	
	
	DECLARE vTime TIME DEFAULT '00:00:00';
	DECLARE vDone BOOLEAN DEFAULT FALSE;
	DECLARE cursorHorary CURSOR FOR
		SELECT cValue FROM tParameter WHERE cKey LIKE 'INFER_TIME%' ORDER BY cKey;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET vDone = TRUE;
	
	OPEN cursorHorary;
	cursorHorary_loop: LOOP
		FETCH cursorHorary INTO vTime;

    	IF(vDone) THEN 
			LEAVE cursorHorary_loop;
		END IF;
	
		SET vOut = fResolveTime(vTime, vMarkTime);
    	IF(vOut != '') THEN 
			LEAVE cursorHorary_loop;
		END IF;
		
		
	END LOOP cursorHorary_loop;
	CLOSE cursorHorary;
	
	#return vOut;
	/*
	
	DECLARE vTime1 TIME DEFAULT '00:00:00';
	DECLARE vTime2 TIME DEFAULT '08:00:00';
	DECLARE vTime3 TIME DEFAULT '16:00:00';
	DECLARE vTime4 TIME DEFAULT '20:00:00';
	
	SET vOut = fResolveTime(vTime1, vMarkTime);
	IF(LENGTH(vOut) = 0) THEN
		SET vOut = fResolveTime(vTime2, vMarkTime);
		IF(LENGTH(vOut) = 0) THEN
			SET vOut = fResolveTime(vTime3, vMarkTime);
			IF(LENGTH(vOut) = 0) THEN
				SET vOut = fResolveTime(vTime4, vMarkTime);
			END IF;
		END IF;
	END IF;
*/
	
#	SET vOut = '08:00:00';
	RETURN vOut;
	
END$$

DROP FUNCTION IF EXISTS fResolveTime;
CREATE FUNCTION fResolveTime(vTime TIME, vMarkTime DATETIME) RETURNS varchar(900) 
BEGIN
	DECLARE vOut CHAR(9) DEFAULT '';
	DECLARE vStartRange DATETIME;
	DECLARE	vEndRange DATETIME;
	DECLARE vTemp CHAR(100);
	DECLARE vTolerance INTEGER;
	
	SET vTemp = DATE_FORMAT(vMarkTime, concat('%Y-%m-%d ', vTime));
	IF(HOUR(vMarkTime)=23) THEN
		SET vTemp = TIMESTAMPADD(DAY, 1, vTemp);
	END IF;

	#SELECT cValue INTO vTolerance FROM tParameter WHERE cKey='TOLERANCE_INFERENCE';
	SET vTolerance = fGetTolerance();
	
#return vTolerance;
	SET vStartRange = TIMESTAMPADD(MINUTE, vTolerance * -1, vTemp);
	SET vEndRange = TIMESTAMPADD(MINUTE, vTolerance, vTemp);
#	SET vStartRange = TIMESTAMPADD(HOUR, -2, vTemp);
#	SET vEndRange = TIMESTAMPADD(HOUR, 2, vTemp);
#return vEndRange;
	IF(vMarkTime > vStartRange AND vMarkTime < vEndRange) THEN
		SET vOut = vTime;
	END IF;
	
	RETURN vOut;
	
END$$
	
DROP FUNCTION IF EXISTS fGetTolerance;
CREATE FUNCTION fGetTolerance() RETURNS INTEGER
BEGIN
	DECLARE vOut INTEGER DEFAULT 120;
	IF (EXISTS(SELECT cId FROM tParameter WHERE cKey='TOLERANCE_INFERENCE')) THEN
		SELECT cValue INTO vOut FROM tParameter WHERE cKey='TOLERANCE_INFERENCE';
	END IF;
	RETURN vOut;
END$$

/**
CREATE FUNCTION fGetComment3(vMark DATETIME, vEmployeeId BIGINT(20)) RETURNS CHAR(120)
BEGIN
	DECLARE vOut VARCHAR(120) DEFAULT '';
	
	SELECT tLicenseCause.cName INTO vOut 
	FROM tLicense 
	LEFT JOIN tLicenseCause ON tLicense.cLicenseCause = tLicenseCause.cId 
	WHERE cEmployee = vEmployeeId AND DATE(vMark) BETWEEN cStartDate AND cEndDate;
	
	IF(EXISTS(SELECT cId FROM tFiscalDate WHERE cDate = DATE(vMark))) THEN
		IF(LENGTH(vOut)>0) THEN
			SET vOut = CONCAT(vOut, ', Día Feriado');
		ELSE
			SET vOut = 'Día Feriado';
		END IF;
	END IF;
	
	RETURN vOut;
END$$
*/
DELIMITER ;
