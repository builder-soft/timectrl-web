DELIMITER $$
 
DROP PROCEDURE IF EXISTS pListAttendanceAsExcel3;
CREATE PROCEDURE pListAttendanceAsExcel3(IN vStartDate DATE, IN vEndDate DATE)
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
	
	DECLARE vTurnDayId	BIGINT(20);
	DECLARE vEmployeeId	BIGINT(20);
	DECLARE vEmployeeKey	VARCHAR(15);
	DECLARE vRUT		VARCHAR(12);
#	DECLARE vMins		INTEGER;

	
	/* EMORENO*/
	DECLARE vName	VARCHAR(90);
	DECLARE vArea	VARCHAR(90);	
	DECLARE vCC		VARCHAR(10);
	DECLARE vTurn	VARCHAR(20);
	DECLARE vStart  VARCHAR(10);
	DECLARE vEnd	VARCHAR(10);
	/* EMORENO*/

	DECLARE vTolerance		INTEGER;
	DECLARE vBusinessDay	BOOLEAN DEFAULT FALSE;
	DECLARE vHoursWorkday	INTEGER;
	DECLARE vFlexible		BOOLEAN;
	
	
	DECLARE vDone BOOLEAN DEFAULT FALSE;
	DECLARE cursorEmployee CURSOR FOR
		SELECT a.cId AS cId, a.cKey AS cKey, a.cRUT AS cRUT, a.cName AS cName, b.cName AS cArea, b.cKey AS cCC
		FROM tEmployee AS a
		LEFT JOIN tArea AS b on a.cArea = b.cId
#where a.cid=16;
		ORDER BY cId;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET vDone = TRUE;

	SET vTolerance = fGetTolerance();
	SET vHoursWorkday = fGetHoursWorkday();
	
	
	DROP TABLE IF EXISTS tAttendance_temp;
	CREATE TEMPORARY TABLE tAttendance_temp (
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
#select vCurrent, vEmployeeId;
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
				
				
			/*	
			SET vTurnDayId = fMarkAndUserToTurnDayId3(vCurrent, vEmployeeId);
			SET vBusinessDay =  (SELECT cBusinessDay FROM tTurnDay WHERE cId = vTurnDayId);

			SET vStartMark = fStartMark(vEmployeeKey, vTolerance, vCurrent, vBusinessDay, vTurnDayId, vHoursWorkday);
			SET vStartTime = fStartTime(vStartMark, vBusinessDay, vTurnDayId);
			
			
			IF(vTurnDayId IS NULL) THEN			
				SET vStartMark = fStartMarkDT(vEmployeeKey, vTolerance, vCurrent);
				SET vStartTime = fInferTime(vStartMark);
			ELSE
				SET vStartTime = (SELECT cStartTime FROM tTurnDay WHERE cId = vTurnDayId);
				SET vStartMark = fGetRealMark3(vEmployeeKey, vCurrent, vTolerance, vStartTime); 
			END IF;
			
#select vStartTime;
			SET vStartDiffI = fExtraTimeAsMins5(vStartMark, vStartTime, TRUE);
			SET vStartDiffM = fExtraTime3(vStartDiffI);

			SET vEndMark = fEndMark(vEmployeeKey, vStartMark, vHoursWorkday, vCurrent, vTolerance, vBusinessDay, vTurnDayId);
			SET vEndTime = fEndTime(vEndMark, vStartMark, vBusinessDay, vTurnDayId);
#			SET vEndTime = (SELECT cEndTime FROM tTurnDay WHERE cId = vTurnDayId);
#			SET vEndMark = (SELECT cDate FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND cMarkType=4 AND cDate BETWEEN vStartMark AND TIMESTAMPADD(DAY,1,vStartMark) ORDER BY cDate DESC LIMIT 1);
			
			
			SET vLunchMark = fLunchMark(vEmployeeKey, vStartMark, vHoursWorkday);
#			SET vLunchMark = (SELECT TIME(cDate) FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=2 LIMIT 1);
			SET vReturnMark = fReturnMark(vEmployeeKey, vStartMark, vHoursWorkday, vLunchMark);
#			SET vReturnMark = (SELECT TIME(cDate) FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=3 LIMIT 1);
			
			SET vEndDiffI = fExtraTimeAsMins5(vEndMark, vEndTime, FALSE);
			SET vEndDiffM = fExtraTime3(vEndDiffI);
#			SET vMins = fExtraTimeAsMins3(vStartMark, vStartTime, TRUE);
			SET vMachine = (SELECT cMachine FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=1 LIMIT 1);

			SET vTurn = (SELECT cName FROM tTurn WHERE cId = (SELECT cTurn FROM tR_EmployeeTurn WHERE cEmployee = vEmployeeId LIMIT 1));
			SET vStart = (SELECT cStartTime FROM tTurnDay WHERE cTurn = (SELECT cTurn FROM tR_EmployeeTurn WHERE cEmployee = vEmployeeId) LIMIT 1);
			SET vEnd = (SELECT cEndTime FROM tTurnDay WHERE cTurn = (SELECT cTurn FROM tR_EmployeeTurn WHERE cEmployee = vEmployeeId) LIMIT 1);
		
			SET vComment = fGetComment3(vCurrent, vEmployeeId, vTurnDayId, vBusinessDay, vStartMark, vEndMark);
#select vComment;
*/
				IF(NOT vBusinessDay) THEN
					SET vStartTime = NULL;
					SET vEndTime = NULL;
				END IF;
				
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
			END IF;
			SET vCurrent = DATE_ADD(vCurrent, INTERVAL 1 DAY);
		END WHILE;

	END LOOP cursorEmployee_loop;
	CLOSE cursorEmployee;
	
	SELECT
		cId					AS 'Item',
		cRut				AS 'RUT',
		cName				AS 'Nombre',
		cArea				AS 'Área',
		cCC					AS 'C.Costo',

		fDayOfWeek3(cDate)	AS 'Día',
		cDate				AS 'Fecha',
		TIME(cStartTime)	AS 'Entrada',
		TIME(cStartMark)	AS 'Marca Entrada',
		cStartDiffI			AS 'Extra/Atraso',
		cStartDiffM			AS 'Diferencia',
		
		TIME(cLunchMark)	AS 'Salida a Colación',
		TIME(cReturnMark)	AS 'Regreso de Colación',
		
		TIME(cEndTime)		AS 'Salida',
		TIME(cEndMark)		AS 'Marca Salida',
		cEndDiffI			AS 'Extra/Atraso',
		cEndDiffM			AS 'Diferencia',
		
		cComment			AS 'Comentarios',
		cMachine			AS 'Máquina',
		cTurn				AS 'Turno',
		TIME(cStartTime)	AS 'Entrada Turno',
		TIME(cEndTime)		AS 'Salida Turno'
	FROM tAttendance_temp;
	
	DROP TABLE IF EXISTS tAttendance_temp;
END$$

DELIMITER ;
