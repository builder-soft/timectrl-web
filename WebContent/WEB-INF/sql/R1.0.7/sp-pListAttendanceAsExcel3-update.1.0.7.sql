DROP PROCEDURE IF EXISTS pListAttendanceAsExcel3;
#DROP PROCEDURE IF EXISTS fMarkAndUserToTurnDayId4;
#DROP FUNCTION IF EXISTS fVerifyFiscalDay;
DROP FUNCTION IF EXISTS fExtraTimeAsMins4;
DROP FUNCTION IF EXISTS fMarkAndUserToTurnDayId3;
DROP FUNCTION IF EXISTS fGetRealMark3;
DROP FUNCTION IF EXISTS fGetComment3;

DELIMITER $$
 
CREATE PROCEDURE pListAttendanceAsExcel3(IN vStartDate DATE, IN vEndDate DATE)
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
	
	DECLARE vTurnDayId	BIGINT(20);
	DECLARE vEmployeeId	BIGINT(20);
	DECLARE vEmployeeKey	VARCHAR(15);
	DECLARE vRUT		VARCHAR(12);
	DECLARE vMins		INTEGER;

	/* EMORENO*/
	DECLARE vName	VARCHAR(90);
	DECLARE vArea	VARCHAR(90);	
	DECLARE vCC		VARCHAR(10);
	DECLARE vTurn	VARCHAR(20);
	DECLARE vStart  VARCHAR(10);
	DECLARE vEnd	VARCHAR(10);
	/* EMORENO*/

	DECLARE vDone BOOLEAN DEFAULT FALSE;
	DECLARE cursorEmployee CURSOR FOR
		SELECT a.cId AS cId, a.cKey AS cKey, a.cRUT AS cRUT, a.cName AS cName, b.cName AS cArea, b.cKey AS cCC
		FROM tEmployee AS a
		LEFT JOIN tArea AS b on a.cArea = b.cId;
#where a.cid=483;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET vDone = TRUE;
	
	DROP TABLE IF EXISTS tAttendance_temp;

	CREATE TEMPORARY TABLE tAttendance_temp (
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
		cMachine	BIGINT(20),

		cRut		varchar(12),
		cName		varchar(90),
		cArea		VARCHAR(90),
		cCC			VARCHAR(10),
		cTurn		VARCHAR(20),
		cStart		VARCHAR(10),
		cEnd		VARCHAR(10)		
    ) ENGINE=innoDB;
	

    /*
	SELECT	cId, cRUT INTO vEmployeeId, vRUT
	FROM	tEmployee 
	WHERE	cKey = vPersonKey;
	*/
    
    SET vEndDate = DATE_ADD(vEndDate, INTERVAL 1 DAY);
    
    OPEN cursorEmployee;
    cursorEmployee_loop: LOOP
    	FETCH cursorEmployee INTO vEmployeeId, vEmployeeKey, vRUT, vName, vArea, vCC;
    	
    	IF(vDone) THEN 
			LEAVE cursorEmployee_loop;
		END IF;
    	
	    SET vCurrent = vStartDate;
		
		WHILE vCurrent != vEndDate DO
#select concat('.', vCurrent, '.'), concat('-', vEmployeeId, '-');
#			SET vTurnDayId = fMarkAndUserToTurnDayId3(DATE('2014-09-01'), vEmployeeId);
			SET vTurnDayId = fMarkAndUserToTurnDayId3(vCurrent, vEmployeeId);
#			SET vTurnDayId = fMarkAndUserToTurnDayId4('2014-09-01', 1);
#select vTurnDayId;
			SET vStartTime = (SELECT cStartTime FROM tTurnDay WHERE cId = vTurnDayId);

			SET vStartMark = fGetRealMark3(vEmployeeKey, vCurrent, 120, vStartTime); 
			
			SET vStartDiffI = fExtraTimeAsMins3(vStartMark, vStartTime, TRUE);
			SET vStartDiffM = fExtraTime3(vStartDiffI);
			
			SET vLunchMark = (SELECT TIME(cDate) FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=2 LIMIT 1);
			SET vReturnMark = (SELECT TIME(cDate) FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=3 LIMIT 1);
			
			SET vEndTime = (SELECT cEndTime FROM tTurnDay WHERE cId = vTurnDayId);
	
			SET vEndMark = (SELECT cDate FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND cMarkType=4 AND cDate BETWEEN vStartMark AND TIMESTAMPADD(DAY,1,vStartMark) ORDER BY cDate DESC LIMIT 1);
#			SET vEndMark = (SELECT cDate FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=4 ORDER BY cDate DESC LIMIT 1);

#			SET vEndDiffI = fExtraTimeAsMins3(vEndMark, vEndTime, FALSE);
#select vEndMark, vEndTime, vCurrent;
#select concat ('->', fExtraTimeAsMins4(vEndMark, vEndTime, FALSE, vCurrent), '<-');

			SET vEndDiffI = fExtraTimeAsMins4(vEndMark, vEndTime, FALSE, vCurrent);
#set vEndDiffI = 50300;
#select vEndDiffI;
			SET vEndDiffM = fExtraTime3(vEndDiffI);
#select 2;	
			SET vMins = fExtraTimeAsMins3(vStartMark, vStartTime, TRUE);
#select 3;			
			SET vMachine = (SELECT cMachine FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=1 LIMIT 1);
#select 4;

			SET vTurn = (SELECT cName FROM tturn WHERE cId = (SELECT cTurn FROM tr_employeeturn WHERE cEmployee = vEmployeeId));
			SET vStart = (SELECT cStartTime FROM tturnday WHERE cTurn = (SELECT cTurn FROM tr_employeeturn WHERE cEmployee = vEmployeeId) LIMIT 1);
			SET vEnd = (SELECT cEndTime FROM tturnday WHERE cTurn = (SELECT cTurn FROM tr_employeeturn WHERE cEmployee = vEmployeeId) LIMIT 1);
		
			SET vComment = fGetComment3(vCurrent, vEmployeeId);
#			SET vComment = IF(fVerifyFiscalDay(vCurrent), "Dia Feriado", "");
			
			INSERT INTO tAttendance_temp
					(cDate   , cStartTime, cStartMark, cStartDiffI, cStartDiffM, 
					cLunchMark, cReturnMark, 
					cEndTime, cEndMark, cEndDiffI, cEndDiffM,
					cMachine, cComment, 
					cRut, cName, cArea, cCC, cTurn, cStart, cEnd)
			VALUES	(vCurrent, vStartTime, TIME(vStartMark), IFNULL(vStartDiffI, 0), vStartDiffM,			 
					vLunchMark, vReturnMark, 
					vEndTime, TIME(vEndMark), IFNULL(vEndDiffI,0), vEndDiffM,
					vMachine, vComment, 
					vRut, vName, vArea, vCC, vTurn, vStart, vEnd);
/**/
			SET vCurrent = DATE_ADD(vCurrent, INTERVAL 1 DAY);
		END WHILE;

	END LOOP cursorEmployee_loop;
	CLOSE cursorEmployee;
	
	SELECT *, fDayOfWeek3(cDate) AS cDayOfWeek FROM tAttendance_temp;
	
#	DROP TABLE tAttendance_temp;
END$$

CREATE FUNCTION fExtraTimeAsMins4(vMark TIMESTAMP, vLimitTime VARCHAR(8), vStart BOOLEAN, vCurrent DATE) RETURNS INTEGER
BEGIN
	DECLARE vOut INTEGER DEFAULT 0; 
	DECLARE vDateMarkAsString VARCHAR(100) DEFAULT '';
	DECLARE vDateMark datetime;
	
	IF(CHAR_LENGTH(vLimitTime)>0) THEN
/*if(vLimitTime='00:00') then
	set vLimitTime='';
end if;*/
		SET vDateMarkAsString = CONCAT(DATE_FORMAT(vCurrent, '%Y-%m-%d'), ' ', vLimitTime);
#set vout = vDateMarkAsString;
#set vDateMark = vDateMarkAsString;
		SET vDateMark = STR_TO_DATE(vDateMarkAsString, '%Y-%m-%d %H:%i:%s');
		
		IF(EXTRACT(HOUR FROM vMark)=23 AND vLimitTime='00:00:00') THEN
			SET vDateMark = TIMESTAMPADD(DAY, 1, vDateMark);
		END IF;
		
		IF(vStart) THEN
			SET vOut = TIMESTAMPDIFF(MINUTE, vMark, vDateMark);
		ELSE
			SET vOut = TIMESTAMPDIFF(MINUTE, vDateMark, vMark);
		END IF;
/*		
*/
	END IF;

	RETURN vOut;
END$$

CREATE FUNCTION fMarkAndUserToTurnDayId3(vMarkTime DATE, vUserId BIGINT(20)) RETURNS BIGINT(20)
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

CREATE FUNCTION fGetRealMark3(vPersonKey VARCHAR(25), vCurrent DATE, vMinutes INTEGER, vTime TIME) RETURNS TIMESTAMP
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

DELIMITER ;
