/*
Respaldar:
mysqldump -u root -padmin timecontrol > database-backup.sql.txt

Restaurar base de datos:
mysql -u root -padmin timecontrol < database-backup.sql.txt


Probar Reporte:
mysql -u root -padmin timecontrol -t < sp-custom-report3.sql.txt

*/
DROP PROCEDURE IF EXISTS pListAttendance3;
DROP FUNCTION IF EXISTS fMarkAndUserToTurnDayId3;
DROP FUNCTION IF EXISTS fExtraTimeAsMins3;
DROP FUNCTION IF EXISTS fExtraTime3;
DROP FUNCTION IF EXISTS fGetRealMark3;
DROP FUNCTION IF EXISTS fDayOfWeek3;
DROP FUNCTION IF EXISTS fGetComment3;

DELIMITER $$

/** Inicio */
CREATE PROCEDURE pListAttendance3(IN vPersonKey INT, IN vStartDate DATE, IN vEndDate DATE)
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
	DECLARE vPersonId	BIGINT(20);
	DECLARE vRUT		VARCHAR(12);
	DECLARE vMins		INTEGER;
	
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
	SELECT cId, cRUT INTO vPersonId, vRUT 
	FROM tEmployee 
	WHERE cKey = vPersonKey;
	
	WHILE vCurrent != vEndDate DO
		SET vTurnDayId = fMarkAndUserToTurnDayId3(vCurrent, vPersonId);
		
		SET vStartTime = (SELECT cStartTime FROM tTurnDay WHERE cId = vTurnDayId);
#		SET vStartMark = (SELECT cDate FROM tAttendanceLog WHERE cEmployeeKey = vPersonKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=1 ORDER BY cDate LIMIT 1);
		SET vStartMark = fGetRealMark3(vPersonKey, vCurrent, 120, vStartTime); 
		
		SET vStartDiffI = fExtraTimeAsMins3(vStartMark, vStartTime, TRUE);
		SET vStartDiffM = fExtraTime3(vStartDiffI);
		
		SET vLunchMark = (SELECT TIME(cDate) FROM tAttendanceLog WHERE cEmployeeKey = vPersonKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=2 LIMIT 1);
		SET vReturnMark = (SELECT TIME(cDate) FROM tAttendanceLog WHERE cEmployeeKey = vPersonKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=3 LIMIT 1);
		
		SET vEndTime = (SELECT cEndTime FROM tTurnDay WHERE cId = vTurnDayId);
#		SET vEndMark = fGetRealMark3(vPersonKey, vCurrent, 60, vEndTime);
		SET vEndMark = (SELECT cDate FROM tAttendanceLog WHERE cEmployeeKey = vPersonKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=4 ORDER BY cDate DESC LIMIT 1);
		SET vEndDiffI = fExtraTimeAsMins3(vEndMark, vEndTime, FALSE);
		SET vEndDiffM = fExtraTime3(vEndDiffI);

		SET vMins = fExtraTimeAsMins3(vStartMark, vStartTime, TRUE);
		
		SET vMachine = (SELECT cMachine FROM tAttendanceLog WHERE cEmployeeKey = vPersonKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=1 LIMIT 1);
		
		SET vComment = fGetComment3(vCurrent, vPersonId);
		
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

CREATE FUNCTION fMarkAndUserToTurnDayId3(vMarkTime TIMESTAMP, vUserId BIGINT(20)) RETURNS BIGINT(20)
BEGIN 
	DECLARE vOut BIGINT(20);
	DECLARE vRTurno BIGINT(20);
	DECLARE vStart DATE;
	DECLARE vEnd DATE;
	DECLARE vDaysCount INTEGER;
	DECLARE vDaysOfTurn INTEGER;
	DECLARE vTurnDay BIGINT(20);
	DECLARE vTurno BIGINT(20);

	SELECT tR_EmployeeTurn.cId INTO vRTurno 
	FROM tR_EmployeeTurn 
	WHERE cEmployee = vUserId AND vMarkTime BETWEEN cStartDate AND cEndDate;
	
	SELECT cTurn INTO vTurno 
	FROM tR_EmployeeTurn 
	WHERE cId = vRTurno;
	
	SELECT cStartDate, cEndDate INTO vStart, vEnd
	FROM tR_EmployeeTurn
	WHERE cId = vRTurno;
	
	SELECT MAX(cDay) INTO vDaysOfTurn 
	FROM tTurnDay
	WHERE cTurn = vTurno;
	
	SET vDaysCount = DATEDIFF(vMarkTime, vStart) % vDaysOfTurn;
	SET vDaysCount = vDaysCount + 1;
	
	SELECT cId INTO vOut 
	FROM tTurnDay 
	WHERE cTurn = vTurno AND cDay = vDaysCount;
	
	RETURN vOut;
END$$

CREATE FUNCTION fExtraTimeAsMins3(vMark TIMESTAMP, vLimitTime CHAR(8), vStart BOOLEAN) RETURNS INTEGER
BEGIN
	DECLARE vOut INTEGER DEFAULT 0;
	DECLARE vDateMarkAsString CHAR(100) DEFAULT '';
	DECLARE vDateMark TIMESTAMP;
	
	IF(CHAR_LENGTH(vLimitTime)>0) THEN
		SET vDateMarkAsString = concat(DATE_FORMAT(vMark, '%Y-%m-%d'), ' ', vLimitTime);
		SET vDateMark = STR_TO_DATE(vDateMarkAsString, '%Y-%m-%d %H:%i:%S');

		IF(EXTRACT(HOUR FROM vMark)=23 AND vLimitTime='00:00:00') THEN
			SET vDateMark = TIMESTAMPADD(DAY, 1, vDateMark);
		END IF;
		
		IF(vStart) THEN
			SET vOut = TIMESTAMPDIFF(MINUTE, vMark, vDateMark);
		ELSE
			SET vOut = TIMESTAMPDIFF(MINUTE, vDateMark, vMark);
		END IF;

	END IF;
	
	RETURN vOut;
END$$

CREATE FUNCTION fExtraTime3(vMinutes INTEGER) RETURNS VARCHAR(9)
BEGIN
	DECLARE vOut VARCHAR(9) DEFAULT '';
	
	IF(vMinutes != 0) THEN
		SET vOut = TIMESTAMPADD(MINUTE, vMinutes, MAKETIME(0,0,0));
	END IF;

	RETURN vOut;
	
END$$

CREATE FUNCTION fGetRealMark3(vPersonKey VARCHAR(25), vCurrent TIMESTAMP, vMinutes INTEGER, vTime TIME) RETURNS TIMESTAMP
BEGIN
	DECLARE vOut TIMESTAMP;

	SELECT cDate INTO vOut
	FROM tAttendanceLog 
	WHERE	cEmployeeKey = vPersonKey AND 
			DATE(cDate) = DATE(vCurrent) AND 
			TIME(cDate) BETWEEN TIMESTAMPADD(MINUTE, (vMinutes*-1), TIME(vTime)) AND 
			TIMESTAMPADD(MINUTE, vMinutes, TIME(vTime))
	LIMIT 1;

	return vOut;
	
END$$ 

CREATE FUNCTION fDayOfWeek3(vMarkTime DATE) RETURNS CHAR(10)
BEGIN 
	DECLARE vOut CHAR(10) DEFAULT '';
	
	CASE DAYOFWEEK(vMarkTime)
		WHEN 1 THEN SET vOut = 'Domingo';
		WHEN 2 THEN SET vOut = 'Lunes';
		WHEN 3 THEN SET vOut = 'Martes';
		WHEN 4 THEN SET vOut = 'Miercoles';
		WHEN 5 THEN SET vOut = 'Jueves';
		WHEN 6 THEN SET vOut = 'Viernes';
		WHEN 7 THEN SET vOut = 'Sabado';
		ELSE SET vOut = '';
	END CASE;
	
	RETURN vOut;
END$$

CREATE FUNCTION fGetComment3(vMark TIMESTAMP, vEmployeeId BIGINT(20)) RETURNS CHAR(120)
BEGIN
	DECLARE vOut VARCHAR(120) DEFAULT '';
	
	SELECT tLicenseCause.cName INTO vOut 
	FROM tLicense 
	LEFT JOIN tLicenseCause ON tLicense.cLicenseCause = tLicenseCause.cId 
	WHERE cEmployee = vEmployeeId AND DATE(vMark) BETWEEN cStartDate AND cEndDate;
	
	RETURN vOut;
END$$

DELIMITER ;

