DELIMITER $$

/****************************************************************/
DROP PROCEDURE IF EXISTS pListAttendance3;
CREATE PROCEDURE pListAttendance3(IN vEmployeeId BIGINT(20), IN vStartDate DATE, IN vEndDate DATE)
BEGIN
	DECLARE vCurrent	DATE;
	DECLARE vStartTime	TIMESTAMP;
	DECLARE vStartMark	TIMESTAMP;
	DECLARE vStartDiffI	INTEGER;
	DECLARE vStartDiffM	VARCHAR(10);
	
	DECLARE vLunchMark	TIMESTAMP;
	DECLARE vReturnMark	TIMESTAMP;
	
	DECLARE vEndTime	TIMESTAMP;
	DECLARE vEndMark	TIMESTAMP;
	DECLARE vEndDiffI	INTEGER;
	DECLARE vEndDiffM	VARCHAR(10);
	
	DECLARE vComment	VARCHAR(120) DEFAULT '';
	DECLARE vMachine	BIGINT(20);
	
/**Variables locales */	
	DECLARE vTurnDayId		BIGINT(20);
	DECLARE vEmployeeKey	VARCHAR(25);
	DECLARE vRUT			VARCHAR(12);
#	DECLARE vMins			INTEGER;
	
	DECLARE vUpperLimit		DATETIME;
	DECLARE vLowerLimit		DATETIME;
	
	DECLARE vTolerance		INTEGER;
	DECLARE vBusinessDay	BOOLEAN DEFAULT FALSE;
	DECLARE vHoursWorkday	INTEGER;
	DECLARE vFlexible		BOOLEAN;
	
	SET vTolerance = fGetTolerance();
	SET vHoursWorkday = fGetHoursWorkday();
	
	DROP TEMPORARY TABLE IF EXISTS tAttendance_temp;
	CREATE TEMPORARY TABLE tAttendance_temp(
		cId			BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		cDate		DATE NOT NULL,
		
		cStartTime	TIMESTAMP NULL,
		cStartMark	TIMESTAMP NULL,
		cStartDiffI	INTEGER,
		cStartDiffM	VARCHAR(10),
		
		cLunchMark	TIMESTAMP NULL,
		cReturnMark	TIMESTAMP NULL,
		
		cEndTime	TIMESTAMP NULL,
		cEndMark	TIMESTAMP NULL,
		cEndDiffI	INTEGER,
		cEndDiffM	VARCHAR(10),
		
		cComment	VARCHAR(120),
		cMachine	BIGINT(20)
    ) Engine=memory;
	
    SET vCurrent = vStartDate;
    SET vEndDate = DATE_ADD(vEndDate, INTERVAL 1 DAY);
    
	SELECT cKey, cRUT INTO vEmployeeKey, vRUT 
	FROM tEmployee 
	WHERE cId = vEmployeeId;
	
	WHILE vCurrent != vEndDate DO
		SET vFlexible = fIsFlexible(vCurrent, vEmployeeId);
		SET vComment = '';
		IF(vFlexible IS NULL) THEN
			SET vComment = fAppendComment(vComment, 'Sin turno');			
		ELSE
			IF(vFlexible) THEN
				SET vStartMark = fStartMark(vEmployeeKey, vTolerance, vCurrent, NULL, TRUE, NULL);
#select vStartMark, vEmployeeId, vTolerance, TRUE;
				SET vTurnDayId = fMarkAndUserToTurnDayId4(vStartMark, vEmployeeId, vTolerance, TRUE);
				SET vBusinessDay =  (SELECT cBusinessDay FROM tTurnDay WHERE cId = vTurnDayId);
			ELSE
				SET vTurnDayId = fMarkAndUserToTurnDayId4(vCurrent, vEmployeeId, vTolerance, FALSE);
				SET vBusinessDay =  (SELECT cBusinessDay FROM tTurnDay WHERE cId = vTurnDayId);
#select vEmployeeKey, vTolerance, vCurrent, vBusinessDay, FALSE, vTurnDayId;
				SET vStartMark = fStartMark(vEmployeeKey, vTolerance, vCurrent, vBusinessDay, FALSE, vTurnDayId);
			END IF;
			
#select vFlexible, vStartMark, vTurnDayId, vBusinessDay;
#			SET vTurnDayId = fMarkAndUserToTurnDayId4(vCurrent, vEmployeeId, vTolerance, vFlexible);
#select vFlexible, vTurnDayId;
#			SET vStartMark = fStartMark(vEmployeeKey, vTolerance, vCurrent, vBusinessDay, vFlexible, vTurnDayId);
#select vStartMark;		
#			SET vTurnDayId = fMarkAndUserToTurnDayId4(vCurrent, vEmployeeId, vTolerance);
#select vTurnDayId;
#select * from tturnday where cid=vTurnDayId;
			
#			SET vBusinessDay =  (SELECT cBusinessDay FROM tTurnDay WHERE cId = vTurnDayId);
#select vBusinessDay;
#			SET vStartMark = fStartMark(vEmployeeKey, vTolerance, vCurrent, vBusinessDay, vTurnDayId, vHoursWorkday);

			SET vStartTime = fStartTime(vStartMark, vBusinessDay, vTurnDayId);
#select vStartMark, vBusinessDay, vTurnDayId, '=', vStartTime; 			
#select vStartMark, vStartTime, TRUE, '|', vStartMark, vBusinessDay, vTurnDayId;			
			SET vStartDiffI = fExtraTimeAsMins5(vStartMark, vStartTime, TRUE);
#select 1;
			SET vStartDiffM = fExtraTime3(vStartDiffI);
#select vEmployeeKey, vStartMark, vHoursWorkday, vCurrent, vTolerance, vBusinessDay, vTurnDayId;
			SET vEndMark = fEndMark(vEmployeeKey, vStartMark, vHoursWorkday, vCurrent, vTolerance, vBusinessDay, vTurnDayId);
#select vEmployeeKey, vStartMark, vHoursWorkday, vCurrent, vTolerance, vBusinessDay, vTurnDayId, '=', vEndMark;
			SET vEndTime = fEndTime(vEndMark, vStartMark, vBusinessDay, vTurnDayId);
#select vEndMark, vStartMark, vBusinessDay, vTurnDayId, vEndTime;

			SET vLunchMark = fLunchMark(vEmployeeKey, vStartMark, vHoursWorkday);
			
			SET vReturnMark = fReturnMark(vEmployeeKey, vStartMark, vHoursWorkday, vLunchMark);
			SET vEndDiffI = fExtraTimeAsMins5(vEndMark, vEndTime, FALSE);
			SET vEndDiffM = fExtraTime3(vEndDiffI);
			SET vMachine = (SELECT cMachine FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=1 LIMIT 1);
			SET vComment = fGetComment3(vCurrent, vEmployeeId, vTurnDayId, vBusinessDay, vStartMark, vEndMark);
	
			IF(NOT vBusinessDay) THEN
				SET vStartTime = NULL;
				SET vEndTime = NULL;
			END IF;
		
		END IF;
		
		INSERT INTO tAttendance_temp
				(cDate   , cStartTime, cStartMark, cStartDiffI, cStartDiffM, 
				cLunchMark, cReturnMark, 
				cEndTime, cEndMark, cEndDiffI, cEndDiffM,
				cMachine, cComment)
		VALUES	(vCurrent, vStartTime, vStartMark, vStartDiffI, vStartDiffM,			 
				vLunchMark, vReturnMark, 
				vEndTime, vEndMark, vEndDiffI, vEndDiffM,
				vMachine, vComment);

		SET vCurrent = DATE_ADD(vCurrent, INTERVAL 1 DAY);
	END WHILE;
	
	SELECT  cId, 
			cDate, 
			IFNULL(TIME(cStartTime),'') AS cStartTime, 
			IFNULL(TIME(cStartMark),'') AS cStartMark, 
			fStartDiffInSelect(cStartDiffI, cStartMark, cEndMark) AS cStartDiffI, 
#			IFNULL(cStartDiffI, '') AS cStartDiffI, 
			IFNULL(cStartDiffM, '') AS cStartDiffM, 
			IFNULL(TIME(cLunchMark), '') AS cLunchMark, 
			IFNULL(TIME(cReturnMark), '') AS cReturnMark, 
			IFNULL(TIME(cEndTime), '') AS cEndTime, 
			IFNULL(TIME(cEndMark), '') AS cEndMark, 
			fEndDiffInSelect(cEndDiffI, cStartMark, cEndMark) AS cEndDiffI,
#			IFNULL(cEndDiffI,'') AS cEndDiffI, 
			IFNULL(cEndDiffM,'') AS cEndDiffM, 
			cComment, 
			IFNULL(cMachine,'') AS cMachine,
			fDayOfWeek3(cDate) AS cDayOfWeek, 
			vRUT AS cRUT /* Este campo debe desaparecer */ 
	FROM tAttendance_temp;
	
	DROP TEMPORARY TABLE tAttendance_temp;
END$$


DELIMITER ;
