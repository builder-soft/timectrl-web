DROP PROCEDURE IF EXISTS pListAttendanceAsExcel3;
DROP PROCEDURE IF EXISTS pTest;

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
#select concat('.', vCurrent, '.');
#			SET vTurnDayId = fMarkAndUserToTurnDayId3(DATE('2014-09-01'), vEmployeeId);
			SET vTurnDayId = fMarkAndUserToTurnDayId3(vCurrent, vEmployeeId);
#select vTurnDayId;
			SET vStartTime = (SELECT cStartTime FROM tTurnDay WHERE cId = vTurnDayId);
			SET vStartMark = fGetRealMark3(vEmployeeKey, vCurrent, 120, vStartTime); 
			
			SET vStartDiffI = fExtraTimeAsMins3(vStartMark, vStartTime, TRUE);
			SET vStartDiffM = fExtraTime3(vStartDiffI);
			
			SET vLunchMark = (SELECT TIME(cDate) FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=2 LIMIT 1);
			SET vReturnMark = (SELECT TIME(cDate) FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=3 LIMIT 1);
			
			SET vEndTime = (SELECT cEndTime FROM tTurnDay WHERE cId = vTurnDayId);
	
			SET vEndMark = (SELECT cDate FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=4 ORDER BY cDate DESC LIMIT 1);
			SET vEndDiffI = fExtraTimeAsMins3(vEndMark, vEndTime, FALSE);
			SET vEndDiffM = fExtraTime3(vEndDiffI);
	
			SET vMins = fExtraTimeAsMins3(vStartMark, vStartTime, TRUE);
			
			SET vMachine = (SELECT cMachine FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=1 LIMIT 1);
			
			/* EMORENO
			SET vName = (SELECT cName FROM temployee WHERE cKey = vPersonKey);			 
			SET vArea = (SELECT cName FROM tarea WHERE cId = (SELECT cArea FROM temployee WHERE cKey = vPersonKey));
			SET vCC   = (SELECT cKey  FROM tarea WHERE cId = (SELECT cArea FROM temployee WHERE cKey = vPersonKey));
			*/
			SET vTurn = (SELECT cName FROM tturn WHERE cId = (SELECT cTurn FROM tr_employeeturn WHERE cEmployee = vEmployeeId));
			SET vStart = (SELECT cStartTime FROM tturnday WHERE cTurn = (SELECT cTurn FROM tr_employeeturn WHERE cEmployee = vEmployeeId) LIMIT 1);
			SET vEnd = (SELECT cEndTime FROM tturnday WHERE cTurn = (SELECT cTurn FROM tr_employeeturn WHERE cEmployee = vEmployeeId) LIMIT 1);
			/* EMORENO*/		
		
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
			
			SET vCurrent = DATE_ADD(vCurrent, INTERVAL 1 DAY);
		END WHILE;

	END LOOP cursorEmployee_loop;
	CLOSE cursorEmployee;
	
	SELECT *, fDayOfWeek3(cDate) AS cDayOfWeek FROM tAttendance_temp;
	
#	DROP TABLE tAttendance_temp;
END$$

DELIMITER ;
