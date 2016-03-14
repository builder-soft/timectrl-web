DROP PROCEDURE IF EXISTS pGetLaterCount;

DELIMITER $$
 
CREATE PROCEDURE pGetLaterCount(IN vDate DATETIME)
BEGIN
#	DECLARE vCurrent	DATE;
	DECLARE vStartTime	TIMESTAMP;
	DECLARE vStartDiffI	INTEGER;
#	DECLARE vStartDiffM	VARCHAR(10);
#	
#	DECLARE vLunchMark	TIMESTAMP;
#	DECLARE vReturnMark	TIMESTAMP;
#	
#	DECLARE vEndTime	TIMESTAMP;
#	DECLARE vEndMark	TIMESTAMP;
#	DECLARE vEndDiffI	INTEGER;
#	DECLARE vEndDiffM	VARCHAR(10);
#	
#	DECLARE vComment	VARCHAR(120) DEFAULT '';
#	DECLARE vMachine	BIGINT(20);
#	
	DECLARE vTurnDayId	BIGINT(20);
	DECLARE vEmployeeId	BIGINT(20);
	DECLARE vEmployeeKey	VARCHAR(25);
#	DECLARE vRUT		VARCHAR(12);
#	DECLARE vMins		INTEGER;

	DECLARE vBusinessDay	BOOLEAN DEFAULT FALSE;
	DECLARE vTolerance		INTEGER;
	DECLARE vHoursWorkday	INTEGER;
	DECLARE vFlexible		BOOLEAN;
	DECLARE vStartMark	TIMESTAMP;


	DECLARE vLaterCount		INTEGER DEFAULT 0; 
	DECLARE vEmployeeCount	INTEGER;

	DECLARE vDone BOOLEAN DEFAULT FALSE;
	DECLARE cursorEmployee CURSOR FOR
		SELECT a.cId AS cId, a.cKey AS cKey
		FROM tEmployee AS a
		WHERE a.cEnabled=TRUE
; #and cid=708;


	DECLARE CONTINUE HANDLER FOR NOT FOUND SET vDone = TRUE;
	
	SELECT	COUNT(cId) INTO vEmployeeCount
	FROM	tEmployee
	WHERE	cEnabled=TRUE
; #and cid=708;
	
	SET vTolerance = fGetTolerance();
	SET vHoursWorkday = fGetHoursWorkday();

#    SET vEndDate = DATE_ADD(vEndDate, INTERVAL 1 DAY);
    
    OPEN cursorEmployee;
    cursorEmployee_loop: LOOP
    	FETCH cursorEmployee INTO vEmployeeId, vEmployeeKey;
    	
    	IF(vDone) THEN 
			LEAVE cursorEmployee_loop;
		END IF;
    	
#	    SET vCurrent = vStartDate;
#		WHILE vCurrent != vEndDate DO
			SET vFlexible = fIsFlexible(vDate, vEmployeeId);
#			SET vComment = '';
#			IF(NOT vFlexible IS NULL) THEN
#				SET vComment = fAppendComment(vComment, 'Sin turno');			
#			ELSE
				IF(vFlexible) THEN
					SET vStartMark = fStartMark(vEmployeeKey, vTolerance, vDate, NULL, TRUE, NULL);
					SET vTurnDayId = fMarkAndUserToTurnDayId4(vStartMark, vEmployeeId, vTolerance, TRUE);
					SET vBusinessDay =  (SELECT cBusinessDay FROM tTurnDay WHERE cId = vTurnDayId);
				ELSE
					SET vTurnDayId = fMarkAndUserToTurnDayId4(vDate, vEmployeeId, vTolerance, FALSE);
					SET vBusinessDay =  (SELECT cBusinessDay FROM tTurnDay WHERE cId = vTurnDayId);
					SET vStartMark = fStartMark(vEmployeeKey, vTolerance, vDate, vBusinessDay, FALSE, vTurnDayId);
				END IF;
		
				SET vStartTime = fStartTime(vStartMark, vBusinessDay, vTurnDayId);
				SET vStartDiffI = fExtraTimeAsMins6(vStartMark, vStartTime, TRUE, vTurnDayId);
				
#				select vStartMark, vStartTime, vEmployeeId, vEmployeeKey, vStartDiffI; 
				
				IF(vStartDiffI < 0) THEN
					SET vLaterCount = vLaterCount + 1;
#					SET vStartDiffM = fExtraTime3(vStartDiffI);
#					SET vEndMark = fEndMark(vEmployeeKey, vStartMark, vHoursWorkday, vCurrent, vTolerance, vBusinessDay, vTurnDayId);
#					SET vEndTime = fEndTime(vEndMark, vStartMark, vBusinessDay, vTurnDayId);
#					
#					SET vLunchMark = fLunchMark(vEmployeeKey, vStartMark, vHoursWorkday);
#					
#					SET vReturnMark = fReturnMark(vEmployeeKey, vStartMark, vHoursWorkday, vLunchMark);
#					SET vEndDiffI = fExtraTimeAsMins6(vEndMark, vEndTime, FALSE, vTurnDayId);
#					SET vEndDiffM = fExtraTime3(vEndDiffI);
#					SET vMachine = (SELECT cMachine FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=1 LIMIT 1);
#					SET vComment = fGetComment3(vCurrent, vEmployeeId, vTurnDayId, vBusinessDay, vStartMark, vEndMark);
#			
#					IF(NOT vBusinessDay) THEN
#						SET vStartTime = NULL;
#						SET vEndTime = NULL;
#					END IF;
#					
#					INSERT INTO tAttendance_temp
#							(cDate   , cStartTime, cStartMark, cStartDiffI, cStartDiffM, 
#							cLunchMark, cReturnMark, 
#							cEndTime, cEndMark, cEndDiffI, cEndDiffM,
#							cMachine, cComment, 
#							cRut, cName, cArea, cCC, cTurn, cStart, cEnd)
#					VALUES	(vCurrent, vStartTime, TIME(vStartMark), IFNULL(vStartDiffI, 0), vStartDiffM,			 
#							vLunchMark, vReturnMark, 
#							vEndTime, TIME(vEndMark), IFNULL(vEndDiffI,0), vEndDiffM,
#							vMachine, vComment, 
#							vRut, vName, vArea, vCC, vTurn, vStart, vEnd);
				END IF;
				
#			END IF;
#			SET vCurrent = DATE_ADD(vCurrent, INTERVAL 1 DAY);
#		END WHILE;

	END LOOP cursorEmployee_loop;
	CLOSE cursorEmployee;

	SELECT vLaterCount, vEmployeeCount; 
	
	
#	SELECT 
#		cId														AS 'Item',
#		cDate													AS 'Fecha',
#		IFNULL(TIME(cStartTime),'')								AS 'Entrada',
#		IFNULL(TIME(cStartMark),'')								AS 'Marca Entrada',
#		fStartDiffInSelect(cStartDiffI, cStartMark, cEndMark)	AS 'Extra/Atraso',
#		IFNULL(cStartDiffM, '')									AS 'Diferencia',
#
#		IFNULL(TIME(cLunchMark), '')							AS 'Salida a Colación',
#		IFNULL(TIME(cReturnMark), '')							AS 'Regreso de Colación',
#
#		IFNULL(TIME(cEndTime), '')								AS 'Salida',
#		IFNULL(TIME(cEndMark), '')								AS 'Marca Salida',
#
#		fEndDiffInSelect(cEndDiffI, cStartMark, cEndMark)		AS 'Extra/Atraso',
#		IFNULL(cEndDiffM,'')									AS 'Diferencia',
#
#		cComment												AS 'Comentarios',
#		IFNULL(cMachine,'')										AS 'Máquina',
#		
#		cRut													AS 'RUT',
#		cName													AS 'Nombre',
#		cArea													AS 'Área',
#		cCC														AS 'C.Costo',
#		IFNULL(cTurn,'')										AS 'Turno',
#			
#		fDayOfWeek3(cDate)										AS 'Día'
#	FROM tAttendance_temp;
#	
#	DROP TABLE IF EXISTS tAttendance_temp;
	
END$$

DELIMITER ;
