DELIMITER $$

/** 
SELECT *
FROM tAttendanceLog 
where cemployeekey = '204' and date(cdate) between date('2014-11-01') and date('2014-11-30') order by cdate;

Se ordena la secuencia de ejecucion de los SP pListAttendance3 y pListAttendanceAsExcel3

SELECT *
FROM tAttendanceLog 
WHERE cEmployeeKey = '204' 
        AND cDate >= fDate2DateTime('2014-11-12',0,0,0)
#        and cMarkType in (1, 4) 
ORDER BY cDate;

Consulta de prueba:
select * 
from tattendancelog 
where cemployeekey='211' 
and date(cdate) between date('2015-02-01') and date('2015-02-15')
and cmarktype in (1,4)
order by cdate ;

*/
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
#select vCurrent;
		SET vTurnDayId = fMarkAndUserToTurnDayId3(vCurrent, vEmployeeId);
		SET vBusinessDay =  (SELECT cBusinessDay FROM tTurnDay WHERE cId = vTurnDayId);
#select vEmployeeKey, vTolerance, vCurrent, vBusinessDay, vTurnDayId, vHoursWorkday;
		SET vStartMark = fStartMark(vEmployeeKey, vTolerance, vCurrent, vBusinessDay, vTurnDayId, vHoursWorkday);
#select vStartMark;
#select vStartMark, vBusinessDay, vTurnDayId;
		SET vStartTime = fStartTime(vStartMark, vBusinessDay, vTurnDayId);
#select vStartTime;

		SET vStartDiffI = fExtraTimeAsMins5(vStartMark, vStartTime, TRUE);
		SET vStartDiffM = fExtraTime3(vStartDiffI);

#select vEmployeeKey, vStartMark, vHoursWorkday, vCurrent, vBusinessDay, vTurnDayId;
		SET vEndMark = fEndMark(vEmployeeKey, vStartMark, vHoursWorkday, vCurrent, vTolerance, vBusinessDay, vTurnDayId);
#select vEndMark, vStartMark, vBusinessDay, vTurnDayId;
		SET vEndTime = fEndTime(vEndMark, vStartMark, vBusinessDay, vTurnDayId);

#select vEmployeeKey, vStartMark, vHoursWorkday;		
		SET vLunchMark = fLunchMark(vEmployeeKey, vStartMark, vHoursWorkday);
		
		
		SET vReturnMark = fReturnMark(vEmployeeKey, vStartMark, vHoursWorkday, vLunchMark);
#select vCurrent, vStartMark, vEndMark, vEndTime, FALSE;
		SET vEndDiffI = fExtraTimeAsMins5(vEndMark, vEndTime, FALSE);
#select vCurrent, vEndDiffI;
		SET vEndDiffM = fExtraTime3(vEndDiffI);
#select vEndDiffM;
		SET vMachine = (SELECT cMachine FROM tAttendanceLog WHERE cEmployeeKey = vEmployeeKey AND DATE(cDate) = DATE(vCurrent) AND cMarkType=1 LIMIT 1);
#select vCurrent, vEmployeeId, vTurnDayId, vBusinessDay;
		SET vComment = fGetComment3(vCurrent, vEmployeeId, vTurnDayId, vBusinessDay, vStartMark, vEndMark);

		IF(NOT vBusinessDay) THEN
			SET vStartTime = NULL;
			SET vEndTime = NULL;
		END IF;
#select vStartMark, TIME(vStartMark);
		INSERT INTO tAttendance_temp
				(cDate   , cStartTime, cStartMark, cStartDiffI, cStartDiffM, 
				cLunchMark, cReturnMark, 
				cEndTime, cEndMark, cEndDiffI, cEndDiffM,
				cMachine, cComment)
		VALUES	(vCurrent, vStartTime, vStartMark, vStartDiffI, vStartDiffM,			 
				vLunchMark, vReturnMark, 
				vEndTime, vEndMark, vEndDiffI, vEndDiffM,
				vMachine, vComment);

#select vStartMark, TIME(vStartMark);
#select * from tAttendance_temp;
#desc tAttendance_temp;
				
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

/****************************************************************/
DROP FUNCTION IF EXISTS fGetHoursWorkday;
CREATE FUNCTION fGetHoursWorkday() RETURNS INTEGER
BEGIN
	DECLARE vOut INTEGER DEFAULT 12;
	
	IF(EXISTS(SELECT cValue FROM tParameter WHERE cKey='HOURS_WORKDAY')) THEN
		SELECT cValue INTO vOut FROM tParameter WHERE cKey='HOURS_WORKDAY' LIMIT 1;
	END IF;

	RETURN vOut;	
END$$

/****************************************************************/
DROP FUNCTION IF EXISTS fDate2DateTime;
CREATE FUNCTION fDate2DateTime(vDate DATE, vHour INTEGER, vMinute INTEGER, vSecond INTEGER) RETURNS DATETIME
BEGIN
	DECLARE vOut DATETIME;
	SET vOut = fToDateTime(YEAR(vDate), MONTH(vDate), DAY(vDate), vHour, vMinute, vSecond);
	RETURN vOut;	
END$$


/****************************************************************/
DROP FUNCTION IF EXISTS fAppendComment;
CREATE FUNCTION fAppendComment(vComment VARCHAR(120), vText VARCHAR(120)) RETURNS CHAR(120)
BEGIN
	DECLARE vOut VARCHAR(120) DEFAULT '';

	IF(LENGTH(vComment)>0) THEN
		SET vOut = CONCAT(vComment, ', ', vText);
	ELSE
		SET vOut = vText;
	END IF;
		
	RETURN vOut;
END$$

DELIMITER ;
