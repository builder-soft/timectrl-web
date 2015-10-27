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
							vBusinessDay BOOLEAN, vFlexible BOOLEAN, vTurnDayId BIGINT(20)) RETURNS TIMESTAMP
BEGIN
	DECLARE vOut		TIMESTAMP DEFAULT NULL;
	DECLARE vMark		TIMESTAMP;
	DECLARE vStart		TIMESTAMP;
	DECLARE vEnd		TIMESTAMP;
	DECLARE vTime		VARCHAR(5);
	
	IF (vFlexible) THEN /* Busca desde las 3 horas del dia anterior, hasta 3 horas despues del día posteior */
		SET vMark := fDate2DateTime(vCurrent, 0, 0, 0);
		SET vStart := TIMESTAMPADD(MINUTE, vTolerance * -1, vMark);
		SET vMark := fDate2DateTime(vCurrent, 23, 59, 59);
		SET vEnd := TIMESTAMPADD(MINUTE, vTolerance * -1, vMark);
		
		SELECT cDate INTO vOut
		FROM tAttendanceLog 
		WHERE cEmployeeKey = vEmployeeKey AND 
			cDate BETWEEN vStart AND vEnd AND
			cMarkType=1 
		ORDER BY cDate ASC 
		LIMIT 1;
		
	ELSE # Si no es flexible, es un horario normal, y tiene horario predefinido.
		IF(vBusinessDay) THEN
			SET vTime = (SELECT cStartTime FROM tTurnDay WHERE cId = vTurnDayId);
			
			SET vMark = CONCAT(vCurrent, ' ', vTime);
			
			SET vStart := TIMESTAMPADD(MINUTE, vTolerance * -1, vMark);
			SET vEnd := TIMESTAMPADD(MINUTE, vTolerance, vMark);
			SELECT cDate INTO vOut
					FROM tAttendanceLog 
					WHERE cEmployeeKey = vEmployeeKey AND 
						cDate BETWEEN vStart AND vEnd AND
			cMarkType=1
			ORDER BY cDate ASC
			LIMIT 1;
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
	DECLARE vTime VARCHAR(10);
	
	IF(vTurnDayId IS NULL) THEN
		SET vOut = fInferTime(vStartMark);
	ELSE
		IF(vBusinessDay) THEN
			SELECT cStartTime INTO vTime FROM tTurnDay WHERE cId = vTurnDayId;
			
			IF(TIME(vTime)=0 AND HOUR(vStartMark)>22) THEN
				SET vStartMark = TIMESTAMPADD(DAY, 1, vStartMark);
			END IF;
			
			SET vOut = CONCAT(DATE(vStartMark), ' ', vTime);
		ELSE
			SET vOut = vStartMark;
		END IF;
	END IF;
	
	RETURN vOut;
END$$

/****************************************************************/
DROP FUNCTION IF EXISTS fEndMark;
CREATE FUNCTION fEndMark(	vEmployeeKey VARCHAR(20), vStartMark TIMESTAMP, 
							vHoursWorkday INTEGER, vCurrent DATE, vTolerance INTEGER,
							vBusinessDay BOOLEAN, vTurnDayId BIGINT(20)) RETURNS TIMESTAMP
BEGIN
	DECLARE vOut TIMESTAMP;
	DECLARE vEndTime TIMESTAMP;
		
	IF(vStartMark IS NULL) THEN
		IF (vBusinessDay) THEN
			SET vEndTime = CONCAT(vCurrent, ' ', (SELECT cEndTime FROM tTurnDay WHERE cId = vTurnDayId));
			SET vOut = fGetRealMark3(vEmployeeKey, vTolerance, vEndTime, 4);
		ELSE
			SET vOut = fFindMarkOnDay(vEmployeeKey, vCurrent, 4);
		END IF;
	ELSE
		SELECT cDate INTO vOut
		FROM tAttendanceLog 
		WHERE cEmployeeKey = vEmployeeKey AND 
			cDate BETWEEN vStartMark AND TIMESTAMPADD(HOUR, vHoursWorkday, vStartMark) AND
			cMarkType=4 
		ORDER BY cDate DESC LIMIT 1;
	END IF;

	RETURN vOut;
END$$

/****************************************************************/
DROP FUNCTION IF EXISTS fEndTime;
CREATE FUNCTION fEndTime(	vEndMark TIMESTAMP, vStartMark TIMESTAMP,
							vBusinessDay BOOLEAN, vTurnDayId BIGINT(20)) RETURNS TIMESTAMP
BEGIN
	DECLARE vOut TIMESTAMP;

	IF(vBusinessDay) THEN
		SET vOut = CONCAT(DATE(vEndMark), ' ', (SELECT cEndTime FROM tTurnDay WHERE cId = vTurnDayId));
	ELSE
		SET vOut = vStartMark;
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
	DECLARE vDiff DECIMAL(8,3);
	IF(vStart) THEN
		SET vDiff = TIMESTAMPDIFF(SECOND, vFrom, vTo)/60;
	ELSE
		SET vDiff = TIMESTAMPDIFF(SECOND, vTo, vFrom)/60;
	END IF;
	SET vOut := ROUND(vDiff);
	
	RETURN vOut;
END$$

/****************************************************************/
DROP FUNCTION IF EXISTS fExtraTimeAsMins6;
CREATE FUNCTION fExtraTimeAsMins6(vMark TIMESTAMP, vTime TIMESTAMP, vStart BOOLEAN, vTurnDayId BIGINT(20)) RETURNS INTEGER
BEGIN
	DECLARE vOut			INTEGER DEFAULT 0;
	DECLARE vDiff			DECIMAL(8,3);
	
	DECLARE vInRange		BIT;
	
	/**
	SELECT cEdgePrevIn, cEdgePostIn, cEdgePrevOut, cEdgePostOut
	INTO vEdgePrevIn, vEdgePostIn, vEdgePrevOut, vEdgePostOut
	FROM tTurnDay WHERE cId = vTurnDayId;
	
	SET vStartRange	= TIMESTAMPADD(MINUTE, vEdgePrevOut, vTime);
	SET vEndRange	= TIMESTAMPADD(MINUTE, vEdgePostOut, vTime);
	*/
	
	SET vInRange = fInRange(vMark, vTime, vStart, vTurnDayId);
	IF(vInRange) THEN
#	IF(vMark > vStartRange AND vMark < vEndRange) THEN
		SET vOut = 0;
	ELSE
		IF(vStart) THEN
			SET vDiff = TIMESTAMPDIFF(SECOND, vMark, vTime)/60;
		ELSE
			SET vDiff = TIMESTAMPDIFF(SECOND, vTime, vMark)/60;
		END IF;
		SET vOut := ROUND(vDiff);
	END IF;
	
	RETURN vOut;
END$$

DROP FUNCTION IF EXISTS fInRange;
CREATE FUNCTION fInRange(vMark TIMESTAMP, vTime TIMESTAMP, vStart BOOLEAN, vTurnDayId BIGINT(20)) RETURNS BIT
BEGIN
	DECLARE vOut			BIT;
	DECLARE vEdgePrevIn		INTEGER;
	DECLARE vEdgePostIn		INTEGER;
	DECLARE vEdgePrevOut	INTEGER;
	DECLARE vEdgePostOut	INTEGER;
	DECLARE vStartRange		TIMESTAMP;
	DECLARE vEndRange		TIMESTAMP;

	SELECT cEdgePrevIn, cEdgePostIn, cEdgePrevOut, cEdgePostOut
	INTO vEdgePrevIn, vEdgePostIn, vEdgePrevOut, vEdgePostOut
	FROM tTurnDay WHERE cId = vTurnDayId;
	
	IF(vStart) THEN
		SET vStartRange	= TIMESTAMPADD(MINUTE, vEdgePrevIn, vTime);
		SET vEndRange	= TIMESTAMPADD(MINUTE, vEdgePostIn, vTime);
	ELSE
		SET vStartRange	= TIMESTAMPADD(MINUTE, vEdgePrevOut, vTime);
		SET vEndRange	= TIMESTAMPADD(MINUTE, vEdgePostOut, vTime);
	END IF;
	
	IF(vMark > vStartRange AND vMark < vEndRange) THEN
		SET vOut = TRUE;
	ELSE
		SET vOut = FALSE;
	END IF;
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
	
	IF(HOUR(vTime)=0 AND (HOUR(vMarkTime) >= 24-(vTolerance/60) )) THEN
		SET vTemp = TIMESTAMPADD(DAY, 1, vTemp);
	END IF;
	
	SET vStartRange = TIMESTAMPADD(MINUTE, vTolerance * -1, vTemp);
	SET vEndRange = TIMESTAMPADD(MINUTE, vTolerance, vTemp);
	
	IF(vMarkTime > vStartRange AND vMarkTime < vEndRange) THEN
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
	DECLARE vReason VARCHAR(50);
	
	SELECT tLicenseCause.cName INTO vOut 
	FROM tLicense 
	LEFT JOIN tLicenseCause ON tLicense.cLicenseCause = tLicenseCause.cId 
	WHERE	cEmployee = vEmployeeId AND 
			DATE(vMark) BETWEEN cStartDate AND cEndDate;
	
	IF(EXISTS(SELECT cId FROM tFiscalDate WHERE cDate = DATE(vMark))) THEN
		SELECT cReason INTO vReason FROM tFiscalDate WHERE cDate = DATE(vMark) LIMIT 1;
		SET vOut = fAppendComment(vOut, vReason);
	END IF;
	
	IF(vStartMark IS NULL AND vEndMark IS NULL) THEN
		IF(vBusinessDay = TRUE) THEN
			IF (LENGTH(vOut)=0) THEN
				SET vOut = fAppendComment(vOut, 'Sin marcas');
			END IF;			
		END IF;			
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
	
	RETURN vOut;
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

/****************************************************************/
DROP FUNCTION IF EXISTS fMarkAndUserToTurnDayId2;
DROP FUNCTION IF EXISTS fMarkAndUserToTurnDayId3;
DROP FUNCTION IF EXISTS fMarkAndUserToTurnDayId4;
CREATE FUNCTION fMarkAndUserToTurnDayId4(vMarkTime TIMESTAMP, vEmployeeId BIGINT(20), 
						vTolerance INTEGER, vFlexible BOOLEAN) RETURNS BIGINT(20)
BEGIN 
	DECLARE vOut BIGINT(20) DEFAULT NULL;
	
#	DECLARE vRTurno BIGINT(20);
	DECLARE vStart DATE;
	DECLARE vEnd DATE;
	DECLARE vDaysCount INTEGER;
	DECLARE vDaysOfTurn INTEGER;
	DECLARE vTurnDay BIGINT(20);
	DECLARE vTurn BIGINT(20);
#	DECLARE vFlexible BIT;

	IF(NOT vFlexible IS NULL) THEN	
		/*
		SELECT cTurn INTO vTurno 
		FROM tR_EmployeeTurn 
		WHERE cId = vRTurno;
		 
		SELECT cStartDate, cEndDate, cTurn INTO vStart, vEnd, vTurno
		FROM tR_EmployeeTurn
		WHERE cId = vRTurno;
		 
		SELECT cFlexible INTO vFlexible
		FROM tTurn
		WHERE cId = vTurno;	
		*/
	#return vTurno;
		SELECT cStartDate, cEndDate, cTurn INTO vStart, vEnd, vTurn
	#	SELECT tR_EmployeeTurn.cId INTO vRTurno 
		FROM tR_EmployeeTurn 
		WHERE cEmployee = vEmployeeId AND DATE(vMarkTime) BETWEEN cStartDate AND cEndDate
		LIMIT 1;
#return vTurn;
		IF(vFlexible) THEN
			SET vOut := fFindTurn(vTurn, vMarkTime);
/*		
			SELECT cId INTO vOut 
			FROM tTurnDay 
			WHERE cTurn = vTurn 
				AND vMarkTime BETWEEN 
					TIMESTAMPADD(MINUTE, vTolerance * -1, CONCAT(DATE(vMarkTime), ' ', cStartTime)) AND 
					TIMESTAMPADD(MINUTE, vTolerance, CONCAT(DATE(vMarkTime), ' ', cStartTime));
*/
		ELSE
			SELECT MAX(cDay) INTO vDaysOfTurn 
			FROM tTurnDay
			WHERE cTurn = vTurn;
			
			SET vDaysCount = DATEDIFF(vMarkTime, vStart) % vDaysOfTurn;
			SET vDaysCount = vDaysCount + 1;
			
			SELECT cId INTO vOut 
			FROM tTurnDay 
			WHERE cTurn = vTurn AND cDay = vDaysCount;
		END IF;
	END IF;

	RETURN vOut;
END$$


/****************************************************************/
DROP FUNCTION IF EXISTS fFindTurn;
CREATE FUNCTION fFindTurn(vTurn BIGINT(20), vMark TIMESTAMP) RETURNS BIGINT(20)
BEGIN
	DECLARE vOut BIGINT(20);
	DECLARE vId BIGINT(20);
	
	DECLARE vTime TIME DEFAULT '00:00';
	DECLARE vDone BOOLEAN DEFAULT FALSE;
	DECLARE vTolerance INTEGER;
	DECLARE vTemp VARCHAR(20);
	DECLARE vStartRange TIMESTAMP;
	DECLARE vEndRange TIMESTAMP;
	
	DECLARE cursorHorary CURSOR FOR
		SELECT cId, cStartTime FROM tTurnDay WHERE cTurn = vTurn ORDER BY cStartTime;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET vDone = TRUE;
	
	OPEN cursorHorary;
	cursorHorary_loop: LOOP
		FETCH cursorHorary INTO vId, vTime;

    	IF(vDone) THEN 
			LEAVE cursorHorary_loop;
		END IF;

		SET vTolerance = fGetTolerance();
		
		SET vTemp = DATE_FORMAT(vMark, CONCAT('%Y-%m-%d ', vTime));
		
		IF(HOUR(vTime)=0 AND (HOUR(vMark) >= 24-(vTolerance/60) )) THEN
			SET vTemp = TIMESTAMPADD(DAY, 1, vTemp);
		END IF;
		
		SET vStartRange = TIMESTAMPADD(MINUTE, vTolerance * -1, vTemp);
		SET vEndRange = TIMESTAMPADD(MINUTE, vTolerance, vTemp);
		
		IF(vMark > vStartRange AND vMark < vEndRange) THEN
			SET vOut := vId;
		END IF;

#RETURN vOut;

    	IF(NOT vOut IS NULL) THEN 
			LEAVE cursorHorary_loop;
		END IF;
		
	END LOOP cursorHorary_loop;
	CLOSE cursorHorary;

	RETURN vOut;
	
END$$

/****************************************************************/
DROP FUNCTION IF EXISTS fIsFlexible;
CREATE FUNCTION fIsFlexible(vMarkTime DATE, vEmployeeId BIGINT(20)) RETURNS BOOLEAN
BEGIN 
	DECLARE vOut BOOLEAN DEFAULT NULL;
	DECLARE vRTurn BIGINT(20);
	DECLARE vTurnDay BIGINT(20);
	DECLARE vTurn BIGINT(20);

	SELECT cId INTO vRTurn
	FROM tR_EmployeeTurn 
	WHERE cEmployee = vEmployeeId AND vMarkTime BETWEEN cStartDate AND cEndDate
	LIMIT 1;
	
	SELECT cTurn INTO vTurn
	FROM tR_EmployeeTurn
	WHERE cId = vRTurn;
	
	SELECT cFlexible INTO vOut
	FROM tTurn
	WHERE cId = vTurn;
		
	RETURN vOut;
END$$

/****************************************************************/
DROP FUNCTION IF EXISTS fGetBusinessDay;
CREATE FUNCTION fGetBusinessDay(vEmployeeId BIGINT(20), vEmployeeKey VARCHAR(20), 
								vTolerance INTEGER, vDate DATE) RETURNS BOOLEAN
BEGIN 
	DECLARE vOut		BOOLEAN DEFAULT NULL;
	DECLARE vTurnDayId	BIGINT(20);
	DECLARE vStartMark	TIMESTAMP;
	
	IF(fIsFlexible(vDate, vEmployeeId)) THEN
		SET vStartMark = fStartMark(vEmployeeKey, vTolerance, vDate, NULL, TRUE, NULL);

		SET vTurnDayId = fMarkAndUserToTurnDayId4(vDate, vEmployeeId, vTolerance, TRUE);
		SET vOut =  (SELECT cBusinessDay FROM tTurnDay WHERE cId = vTurnDayId);
	ELSE
		SET vTurnDayId = fMarkAndUserToTurnDayId4(vDate, vEmployeeId, vTolerance, FALSE);
		SET vOut =  (SELECT cBusinessDay FROM tTurnDay WHERE cId = vTurnDayId);

	END IF;
					
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
