DELIMITER $$
/**

select * 
from tattendancelog 
where cemployeekey='305' 
and date(cdate) between date('2015-02-26') and date('2015-03-03')
and cmarktype in (1,4)
order by cdate ;

*/
DROP FUNCTION IF EXISTS fStartMark;
CREATE FUNCTION fStartMark(	vEmployeeKey VARCHAR(20), vTolerance INTEGER, vCurrent DATE,
							vBusinessDay BOOLEAN, vTurnDayId BIGINT(20), vHoursWorkday INTEGER) RETURNS TIMESTAMP
BEGIN
	DECLARE vOut		TIMESTAMP DEFAULT NULL;
	DECLARE vStartTime	TIMESTAMP;
	DECLARE vStart		TIMESTAMP;
	DECLARE vEnd		TIMESTAMP;
	
	IF(vTurnDayId IS NULL) THEN /* Es un día que tiene turno diferido */
		SELECT cDate INTO vStart /* Busca la última marca de salida en el día anterior */
		FROM tAttendanceLog 
		WHERE cEmployeeKey = vEmployeeKey
			AND cDate BETWEEN TIMESTAMPADD(DAY, -1, fDate2DateTime(vCurrent,0,0,0)) AND TIMESTAMPADD(DAY, -1, fDate2DateTime(vCurrent,23,59,59))
			AND cMarkType=4
		ORDER BY cDate DESC
		LIMIT 1;
#return vStart;
		IF(NOT vStart IS NULL) THEN /* Si tiene marca de salida el día anterior */
			SET vEnd := fDate2DateTime(vCurrent,23,59,59);
			#SET vEnd := TIMESTAMPADD(HOUR, vHoursWorkday, vStart); /* Calcula 15 horas despues de la hora de salida */
#return vEnd;		
			SELECT cDate INTO vOut
			FROM tAttendanceLog 
			WHERE cEmployeeKey = vEmployeeKey AND 
				cDate BETWEEN vStart AND vEnd AND 
				cMarkType=1 
			ORDER BY cDate LIMIT 1;
		END IF;
#return vOut;
		IF (vOut IS NULL) THEN
			SET vStart := fDate2DateTime(vCurrent,0,0,0);
#			SET vStart := TIMESTAMPADD(MINUTE, vTolerance * -1, fDate2DateTime(vCurrent,0,0,0));
			SET vEnd := fDate2DateTime(vCurrent,23,59,59);
#			SET vEnd := TIMESTAMPADD(HOUR, vHoursWorkday, vStart);
#return vEnd;
			SELECT cDate INTO vOut
			FROM tAttendanceLog 
			WHERE cEmployeeKey = vEmployeeKey AND 
				cDate BETWEEN vStart AND vEnd AND 
				cMarkType=1 
			ORDER BY cDate LIMIT 1;
		END IF;
	ELSE
		IF(vBusinessDay) THEN
			SET vStartTime = CONCAT(vCurrent, ' ', (SELECT cStartTime FROM tTurnDay WHERE cId = vTurnDayId));
#			SET vStartTime = (SELECT cStartTime FROM tTurnDay WHERE cId = vTurnDayId);
			SET vOut = fGetRealMark3(vEmployeeKey, vTolerance, vStartTime, 1);
		ELSE
			SET vOut = fFindMarkOnDay(vEmployeeKey, vCurrent, 1);
		END IF;
	END IF;

	RETURN vOut;
END$$

/****************************************************************/
DROP FUNCTION IF EXISTS fStartTime;
CREATE FUNCTION fStartTime(vStartMark TIMESTAMP, vBusinessDay BOOLEAN, vTurnDayId BIGINT(20)) RETURNS TIMESTAMP
BEGIN
	DECLARE vOut TIMESTAMP;
	
	IF(vTurnDayId IS NULL) THEN
		SET vOut = fInferTime(vStartMark);
	ELSE
		IF(vBusinessDay) THEN
			SET vOut = CONCAT(DATE(vStartMark), ' ', (SELECT cStartTime FROM tTurnDay WHERE cId = vTurnDayId));
		ELSE
			SET vOut = vStartMark;
#			SET vOut = TIME(vStartMark);
		END IF;
	END IF;
	
	RETURN vOut;
END$$

/****************************************************************/
DROP FUNCTION IF EXISTS fEndMark;
CREATE FUNCTION fEndMark(	vEmployeeKey VARCHAR(20), vStartMark TIMESTAMP, vHoursWorkday INTEGER, vCurrent DATE, vTolerance INTEGER,
							vBusinessDay BOOLEAN, vTurnDayId BIGINT(20)) RETURNS TIMESTAMP
BEGIN
	DECLARE vOut TIMESTAMP;
	DECLARE vEndTime TIMESTAMP;

	IF(vTurnDayId IS NULL) THEN
		SELECT cDate INTO vOut
		FROM tAttendanceLog 
		WHERE cEmployeeKey = vEmployeeKey AND 
			cDate BETWEEN vStartMark AND TIMESTAMPADD(HOUR, vHoursWorkday, vStartMark) AND
			cMarkType=4 
		ORDER BY cDate DESC LIMIT 1;
	ELSE
		IF(vBusinessDay) THEN
			SET vEndTime = CONCAT(vCurrent, ' ', (SELECT cEndTime FROM tTurnDay WHERE cId = vTurnDayId));
			SET vOut = fGetRealMark3(vEmployeeKey, vTolerance, vEndTime, 4);
/*		
			SELECT cDate INTO vOut
			FROM tAttendanceLog 
			WHERE cEmployeeKey = vEmployeeKey AND 
				DATE(cDate) = DATE(vCurrent) AND 
				cMarkType=4 
			ORDER BY cDate DESC LIMIT 1;
*/
		ELSE
#			SET vOut = fFindMarkOnDay(vEmployeeKey, vCurrent, 4);

			SELECT cDate INTO vOut
			FROM tAttendanceLog 
			WHERE cEmployeeKey = vEmployeeKey AND 
				cDate BETWEEN vStartMark AND TIMESTAMPADD(HOUR, vHoursWorkday, vStartMark) AND
				cMarkType=4 
			ORDER BY cDate DESC LIMIT 1;

		END IF;
	END IF;
	
	RETURN vOut;
END$$

/****************************************************************/
DROP FUNCTION IF EXISTS fEndTime;
CREATE FUNCTION fEndTime(	vEndMark TIMESTAMP, vStartMark TIMESTAMP,
							vBusinessDay BOOLEAN, vTurnDayId BIGINT(20)) RETURNS TIMESTAMP
BEGIN
	DECLARE vOut TIMESTAMP;
	
	IF(vTurnDayId IS NULL) THEN
		SET vOut = fInferTime(vEndMark);		
	ELSE
		IF(vBusinessDay) THEN
			SET vOut = CONCAT(DATE(vEndMark), ' ', (SELECT cEndTime FROM tTurnDay WHERE cId = vTurnDayId));
			#SET vOut = CONCAT((SELECT cEndTime FROM tTurnDay WHERE cId = vTurnDayId);
		ELSE
			SET vOut = vStartMark;
		END IF;
	END IF;
	
	RETURN vOut;
END$$


/****************************************************************/
DROP FUNCTION IF EXISTS fLunchMark;
CREATE FUNCTION fLunchMark(vEmployeeKey VARCHAR(20), vStartMark TIMESTAMP, vHoursWorkday INTEGER) RETURNS TIMESTAMP
BEGIN
	DECLARE vOut TIMESTAMP;
	
	SELECT cDate INTO vOut
	FROM tAttendanceLog 
	WHERE cEmployeeKey = vEmployeeKey AND 
		cDate BETWEEN vStartMark AND TIMESTAMPADD(HOUR, vHoursWorkday, vStartMark) AND
		cMarkType=2 
	LIMIT 1	;
			
	RETURN vOut;
END$$	

/****************************************************************/
DROP FUNCTION IF EXISTS fReturnMark;
CREATE FUNCTION fReturnMark(vEmployeeKey VARCHAR(20), vStartMark TIMESTAMP, vHoursWorkday INTEGER, vLunchMark TIMESTAMP) RETURNS TIMESTAMP
BEGIN
	DECLARE vOut TIMESTAMP;
	SELECT cDate INTO vOut
	FROM tAttendanceLog 
	WHERE cEmployeeKey = vEmployeeKey AND 
		cDate BETWEEN vStartMark AND TIMESTAMPADD(HOUR, vHoursWorkday, vLunchMark) AND
		cMarkType=3 
	LIMIT 1;
	RETURN vOut;
END$$	

/****************************************************************/
DROP FUNCTION IF EXISTS fFindMarkOnDay;
CREATE FUNCTION fFindMarkOnDay(vPersonKey VARCHAR(25), vCurrent DATE, vMarkType INTEGER) RETURNS TIMESTAMP
BEGIN
	DECLARE vOut TIMESTAMP;

	DECLARE vStart TIME;
	DECLARE vEnd TIME;
	
	SET vStart = MAKETIME(0,0,0);
	SET vEnd = MAKETIME(23,59,59);
	
	SELECT	cDate INTO vOut
	FROM	tAttendanceLog 
	WHERE	cEmployeeKey = vPersonKey AND 
			DATE(cDate) = DATE(vCurrent) AND 
			TIME(cDate) BETWEEN vStart AND vEnd
			AND cMarkType=vMarkType
	LIMIT 1;

	RETURN vOut;
END$$

/****************************************************************/
DROP FUNCTION IF EXISTS fExtraTimeAsMins5;
CREATE FUNCTION fExtraTimeAsMins5(vFrom TIMESTAMP, vTo TIMESTAMP, vStart BOOLEAN) RETURNS INTEGER
BEGIN
	DECLARE vOut INTEGER DEFAULT 0;
	DECLARE vDiff DECIMAL(6,3);
	IF(vStart) THEN
		SET vDiff = TIMESTAMPDIFF(SECOND, vFrom, vTo)/60;
	ELSE
		SET vDiff = TIMESTAMPDIFF(SECOND, vTo, vFrom)/60;
	END IF;
	SET vOut := ROUND(vDiff);
	
	RETURN vOut;
END$$

/****************************************************************/
DROP FUNCTION IF EXISTS fGetRealMark3;
CREATE FUNCTION fGetRealMark3(vPersonKey VARCHAR(25), vMinutes INTEGER, vTime TIMESTAMP, vMarkType INTEGER) RETURNS TIMESTAMP
BEGIN
	DECLARE vOut TIMESTAMP;

	SELECT cDate INTO vOut
	FROM tAttendanceLog 
	WHERE	cEmployeeKey = vPersonKey AND 
			cDate BETWEEN	TIMESTAMPADD(MINUTE, (vMinutes*-1), vTime) AND 
							TIMESTAMPADD(MINUTE, vMinutes, vTime) AND
			cMarkType = vMarkType
	LIMIT 1;

	RETURN vOut;
	
END$$ 

/****************************************************************/
DROP FUNCTION IF EXISTS fExtraTimeAsMins3;
CREATE FUNCTION fExtraTimeAsMins3(vMark TIMESTAMP, vLimitTime TIMESTAMP, vStart BOOLEAN) RETURNS INTEGER
BEGIN
	DECLARE vOut INTEGER DEFAULT 0;
	#DECLARE vDateMarkAsString CHAR(100) DEFAULT '';
	#DECLARE vDateMark DATETIME;
	
	IF(vStart) THEN
		SET vOut = TIMESTAMPDIFF(MINUTE, vMark, vLimitTime);
	ELSE
		SET vOut = TIMESTAMPDIFF(MINUTE, vLimitTime, vMark);
	END IF;	
	RETURN vOut;
	
/*
	IF(NOT vLimitTime IS NULL) THEN
		SET vDateMarkAsString = CONCAT(DATE_FORMAT(vMark, '%Y-%m-%d'), ' ', vLimitTime);
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
*/
END$$

/****************************************************************/
DROP FUNCTION IF EXISTS fExtraTime3;
CREATE FUNCTION fExtraTime3(vMinutes INTEGER) RETURNS VARCHAR(10)
BEGIN
	DECLARE vOut VARCHAR(10) DEFAULT '';
	
	SET vOut = TIMESTAMPADD(MINUTE, vMinutes, MAKETIME(0,0,0));

	RETURN vOut;
	
END$$


/****************************************************************/
DROP FUNCTION IF EXISTS fInferTime;
CREATE FUNCTION fInferTime(vMarkTime DATETIME) RETURNS TIMESTAMP
BEGIN
	DECLARE vOut TIMESTAMP DEFAULT NULL;
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

#return vMarkTime;
#return vTime;
		SET vOut = fResolveTime(vTime, vMarkTime);
#return vOut;
    	IF(NOT vOut IS NULL) THEN 
			LEAVE cursorHorary_loop;
		END IF;
		
		
	END LOOP cursorHorary_loop;
	CLOSE cursorHorary;
	

	RETURN vOut;
	
END$$

/****************************************************************/
DROP FUNCTION IF EXISTS fResolveTime;
CREATE FUNCTION fResolveTime(vTime TIME, vMarkTime DATETIME) RETURNS DATETIME 
BEGIN
	DECLARE vOut DATETIME DEFAULT NULL;
	DECLARE vStartRange DATETIME;
	DECLARE	vEndRange DATETIME;
	DECLARE vTemp CHAR(100);
	DECLARE vTolerance INTEGER;

	SET vTolerance = fGetTolerance();
	
	SET vTemp = DATE_FORMAT(vMarkTime, CONCAT('%Y-%m-%d ', vTime));
	
#return vTolerance/60;
	IF(HOUR(vTime)=0 AND (HOUR(vMarkTime) >= 24-(vTolerance/60) )) THEN
		SET vTemp = TIMESTAMPADD(DAY, 1, vTemp);
	END IF;
	
#return vTemp;
	SET vStartRange = TIMESTAMPADD(MINUTE, vTolerance * -1, vTemp);
	SET vEndRange = TIMESTAMPADD(MINUTE, vTolerance, vTemp);
#return vStartRange;	
	
	IF(vMarkTime > vStartRange AND vMarkTime < vEndRange) THEN
		#SET vOut = vTime;
		SET vOut := DATE_FORMAT(vTemp, CONCAT('%Y-%m-%d ', vTime));
	END IF;
	
	RETURN vOut;
	
END$$

/****************************************************************/
DROP FUNCTION IF EXISTS fGetComment3;
CREATE FUNCTION fGetComment3(vMark DATETIME, vEmployeeId BIGINT(20), vTurnDayId BIGINT(20), vBusinessDay BOOLEAN, 
							vStartMark DATETIME, vEndMark DATETIME) RETURNS CHAR(120)
BEGIN
	DECLARE vOut VARCHAR(120) DEFAULT '';
	
	SELECT tLicenseCause.cName INTO vOut 
	FROM tLicense 
	LEFT JOIN tLicenseCause ON tLicense.cLicenseCause = tLicenseCause.cId 
	WHERE	cEmployee = vEmployeeId AND 
			DATE(vMark) BETWEEN cStartDate AND cEndDate;
	
	IF(EXISTS(SELECT cId FROM tFiscalDate WHERE cDate = DATE(vMark))) THEN
		SET vOut = fAppendComment(vOut, 'Día Feriado');
	END IF;
	/**
	IF(vTurnDayId IS NULL) THEN
		SET vOut = fAppendComment(vOut, 'Turno diferido');
	END IF;
	*/
	IF(vStartMark IS NULL AND vEndMark IS NULL) THEN
		SET vOut = fAppendComment(vOut, 'Sin marcas');
	ELSEIF(vStartMark IS NULL) THEN
		SET vOut = fAppendComment(vOut, 'Sin entrada');
	ELSEIF(vEndMark IS NULL) THEN
		SET vOut = fAppendComment(vOut, 'Sin salida');
	END IF;

	RETURN vOut;
END$$

/****************************************************************/
DROP FUNCTION IF EXISTS fStartDiffInSelect;
CREATE FUNCTION fStartDiffInSelect(vStartDiffI INTEGER, vStartMark TIMESTAMP, vEndMark TIMESTAMP) RETURNS CHAR(20)
BEGIN
	DECLARE vOut VARCHAR(20) DEFAULT '';
	
	IF(NOT vStartMark IS NULL) THEN
		IF(vEndMark IS NULL) THEN
			SET vOut = CONCAT('(', vStartDiffI, ')');
		ELSE
			SET vOut = vStartDiffI;
		END IF;
	END IF;

	RETURN vOut;
END$$

/****************************************************************/
DROP FUNCTION IF EXISTS fEndDiffInSelect;
CREATE FUNCTION fEndDiffInSelect(vEndDiffI INTEGER, vStartMark TIMESTAMP, vEndMark TIMESTAMP) RETURNS CHAR(20)
BEGIN
	DECLARE vOut VARCHAR(20) DEFAULT '';

	IF(NOT vEndMark IS NULL) THEN
		IF(vStartMark IS NULL) THEN
			SET vOut = CONCAT('(', vEndDiffI, ')');
		ELSE
			SET vOut = vEndDiffI;
		END IF;
	END IF;
	
	/*
	IF(vEndDiffI IS NULL) THEN
		SET vOut = 'Sin marca.';
	ELSE
		IF(vStartMark IS NULL) THEN
			SET vOut = CONCAT('(', vEndDiffI, ') No marca entrada');
		ELSE
			SET vOut = vEndDiffI;
		END IF;
	END IF;
	*/
	RETURN vOut;
END$$


/****************************************************************/
/**
DROP FUNCTION IF EXISTS fXXX;
CREATE FUNCTION fXXX(	
							vBusinessDay BOOLEAN, vTurnDayId BIGINT(20)) RETURNS VARCHAR(8)
BEGIN
	DECLARE vOut VARCHAR(8);
	IF(vTurnDayId IS NULL) THEN
		
	ELSE
		IF(vBusinessDay) THEN
		
		ELSE

		END IF;
	END IF;
	
	RETURN vOut;
END$$	
	
 */
DELIMITER ;
