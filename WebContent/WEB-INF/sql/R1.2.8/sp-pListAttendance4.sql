DELIMITER $$

/****************************************************************/
DROP PROCEDURE IF EXISTS pListAttendance4;
CREATE PROCEDURE pListAttendance4(IN vEmployeeId BIGINT(20), IN vStartDate DATE, IN vEndDate DATE)
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
	DECLARE vTurnDesc	VARCHAR(13) DEFAULT '';
	DECLARE vMachine	BIGINT(20);
	DECLARE	vTotal		DECIMAL(8,2) DEFAULT '0';
	
/**Variables locales */	
	DECLARE vTurnDayId		BIGINT(20);
	DECLARE vEmployeeKey	VARCHAR(25);
	DECLARE vRUT			VARCHAR(12);
	DECLARE vName			VARCHAR(50);
	
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
		cTurnDesc	VARCHAR(13),
		
		cTotal		DECIMAL(8,2),
		
		cMachine	BIGINT(20)
    ) Engine=memory;
	
    SET vCurrent = vStartDate;
    SET vEndDate = DATE_ADD(vEndDate, INTERVAL 1 DAY);
    
	SELECT cKey, cRUT, cName INTO vEmployeeKey, vRUT, vName 
	FROM tEmployee 
	WHERE cId = vEmployeeId;
	
	WHILE vCurrent != vEndDate DO
		SET vFlexible = fIsFlexible(vCurrent, vEmployeeId);
		SET vComment = '';
		IF(vFlexible IS NULL) THEN
			SET vComment = fAppendComment(vComment, 'Sin turno');
			SET vStartTime = NULL;
			SET vStartMark = NULL;
			SET vStartDiffI = NULL;
			SET vStartDiffM = NULL;
			SET vLunchMark = NULL;
			SET vReturnMark = NULL;
			SET vEndTime = NULL;
			SET vEndMark = NULL;
			SET vEndDiffI = NULL;
			SET vEndDiffM = NULL;
			SET vMachine = NULL;
			SET vTurnDesc = NULL;
#			SET vTotal = NULL;
		ELSE
			IF(vFlexible) THEN
				SET vStartMark = fStartMark(vEmployeeKey, vTolerance, vCurrent, NULL, TRUE, NULL);

				SET vTurnDayId = fMarkAndUserToTurnDayId4(vStartMark, vEmployeeId, vTolerance, TRUE);
				SET vBusinessDay =  (SELECT cBusinessDay FROM tTurnDay WHERE cId = vTurnDayId);
			ELSE
				SET vTurnDayId = fMarkAndUserToTurnDayId4(vCurrent, vEmployeeId, vTolerance, FALSE);
				SET vBusinessDay =  (SELECT cBusinessDay FROM tTurnDay WHERE cId = vTurnDayId);

				SET vStartMark = fStartMark(vEmployeeKey, vTolerance, vCurrent, vBusinessDay, FALSE, vTurnDayId);
			END IF;
						
			SET vStartTime = fStartTime(vStartMark, vBusinessDay, vTurnDayId);
			SET vStartDiffI = fExtraTimeAsMins5(vStartMark, vStartTime, TRUE);
			SET vStartDiffM = fExtraTime3(vStartDiffI);
			SET vEndMark = fEndMark(vEmployeeKey, vStartMark, vHoursWorkday, vCurrent, vTolerance, vBusinessDay, vTurnDayId);
			SET vEndTime = fEndTime(vEndMark, vStartMark, vBusinessDay, vTurnDayId);

			SET vLunchMark = fLunchMark(vEmployeeKey, vStartMark, vHoursWorkday);
			
			SET vReturnMark = fReturnMark(vEmployeeKey, vStartMark, vHoursWorkday, vLunchMark);
			SET vEndDiffI = fExtraTimeAsMins5(vEndMark, vEndTime, FALSE);
			SET vEndDiffM = fExtraTime3(vEndDiffI);
			SET vMachine = (SELECT cMachine FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=1 LIMIT 1);
			SET vComment = fGetComment3(vCurrent, vEmployeeId, vTurnDayId, vBusinessDay, vStartMark, vEndMark);
			SET vTurnDesc = (SELECT CONCAT(cStartTime, ' A ', cEndTime) FROM tTurnDay WHERE cId = vTurnDayId);
#select vCurrent, vTotal;	
			SET vTotal = vTotal + (IFNULL(vStartDiffI, 0) + IFNULL(vEndDiffI,0));
			
			IF(NOT vBusinessDay) THEN
				SET vStartTime = NULL;
				SET vEndTime = NULL;
			END IF;
		
		END IF;
		
		INSERT INTO tAttendance_temp
				(cDate   , cStartTime, cStartMark, cStartDiffI, cStartDiffM, 
				cLunchMark, cReturnMark, 
				cEndTime, cEndMark, cEndDiffI, cEndDiffM,
				cMachine, cComment, cTurnDesc, cTotal)
		VALUES	(vCurrent, vStartTime, vStartMark, vStartDiffI, vStartDiffM,			 
				vLunchMark, vReturnMark, 
				vEndTime, vEndMark, vEndDiffI, vEndDiffM,
				vMachine, vComment, vTurnDesc, vTotal);

		SET vCurrent = DATE_ADD(vCurrent, INTERVAL 1 DAY);
	END WHILE;
	
#	UPDATE	tAttendance_temp SET cTotal = SUM(IFNULL(cStartDiffI, 0)) + SUM(IFNULL(cEndDiffI,0));
	UPDATE	tAttendance_temp SET cTotal = (vTotal / 60);
	
	SELECT  cId							AS 'ITEM', 
			vRUT 						AS 'RUT', 
			UPPER(vName)				AS 'NOMBRE TRABAJADOR',
			fDayOfWeek3(cDate) 			AS 'DIA',
			DATE_FORMAT(cDate,'%d-%m-%Y')	AS 'FECHA',
			IFNULL(TIME(cStartMark),'') AS 'MARCA ENTRADA',
			IFNULL(cStartDiffM, '') 	AS 'EXTRA/ATRASO', 
			IFNULL(TIME(cEndMark), '')	AS 'MARCA SALIDA', 
			IFNULL(cEndDiffM,'')		AS 'EXTRA', 
			cComment					AS 'COMENTARIOS', 
			IFNULL(cTurnDesc,'')		AS 'TURNO',
			cTotal						AS 'TOTAL HORAS'
/*			
			,
			fStartDiffInSelect(cStartDiffI, 
							cStartMark, cEndMark)	AS cStartDiffI,
			IFNULL(TIME(cStartTime),'') 			AS cStartTime, 
			 
			IFNULL(cStartDiffI, 0) AS cStartDiffI2,
			IFNULL(cStartDiffM, '') AS cStartDiffM, 
			IFNULL(TIME(cLunchMark), '') AS cLunchMark, 
			IFNULL(TIME(cReturnMark), '') AS cReturnMark, 
			IFNULL(TIME(cEndTime), '') AS cEndTime, 
			
			fEndDiffInSelect(cEndDiffI, cStartMark, cEndMark) AS cEndDiffI,
			IFNULL(cEndDiffI,0) AS cEndDiffI2, 
			
			IFNULL(cMachine,'') AS cMachine
*/			
	FROM tAttendance_temp;
	
	DROP TEMPORARY TABLE tAttendance_temp;
END$$


DELIMITER ;
