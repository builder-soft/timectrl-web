DROP PROCEDURE if exists pListSummaryReport;
DELIMITER $$

CREATE PROCEDURE pListSummaryReport(IN vBoss BIGINT(20), IN vEmployees VARCHAR(1000), IN vStartMonth INT, IN vStartYear INT, 
									IN vEndMonth INT, IN vEndYear INT)
BEGIN
	DECLARE vCurrent			DATE;
	DECLARE vLast				DATE;
	DECLARE vFirst				DATE;
	DECLARE vFirstMonth			DATE;
	DECLARE vLastMonth			DATE;
	DECLARE vBusinessDayCount	INTEGER DEFAULT 0;
	DECLARE vMarkCount			INTEGER DEFAULT 0;
	DECLARE vDelayCount			INTEGER DEFAULT 0;
	DECLARE vStartMarkCount		INTEGER DEFAULT 0;
	DECLARE vExtraTimeAM		INTEGER DEFAULT 0;
	DECLARE vExtraTimePM		INTEGER DEFAULT 0;
	DECLARE vI					INTEGER;
	DECLARE vJ					INTEGER;
	DECLARE vMax				INTEGER;
	DECLARE vEmployeeKey		VARCHAR(15);
	DECLARE vEmployeeId			BIGINT(20);
	DECLARE vFlexible			BOOLEAN;
	DECLARE vBusinessDay		BOOLEAN;
	DECLARE vTurnDayId			BIGINT(20);
	DECLARE vTolerance			INTEGER;
	DECLARE vHoursWorkday		INTEGER;
	DECLARE vHoliday			BOOLEAN;
	DECLARE vStartMark			DATETIME;
	DECLARE vEndMark			DATETIME;
	DECLARE vStartTime			DATETIME;
	DECLARE vEndTime			DATETIME;
	DECLARE vStartDiffI			INTEGER;
	DECLARE vEndDiffI			INTEGER;
	
	DROP TEMPORARY TABLE IF EXISTS tTemp;
	CREATE TEMPORARY TABLE tTemp (
		cId 				BIGINT(20) NOT NULL auto_increment,
		cStart				DATE  NOT NULL,
		cEnd				DATE  NOT NULL,
		cEmployeeKey		VARCHAR(15) NULL,
		cEmployeeId			BIGINT(20),
		cEmployeeRut		VARCHAR(11),
		cEmployeeName		VARCHAR(50),
		cBusinessDayCount	INTEGER DEFAULT 0,
		cMarkCount			INTEGER DEFAULT 0,
		cDelayCount			INTEGER DEFAULT 0,
		cStartMarkCount		INTEGER DEFAULT 0,
		cExtraTimeAM		INTEGER DEFAULT 0,
		cExtraTimePM		INTEGER DEFAULT 0,
		PRIMARY KEY (cId)
    ) Engine=memory;

	SET vFirst = DATE(CONCAT(vStartYear, '-', vStartMonth, '-01'));
	SET vCurrent = vFirst;
	SET vLast = LAST_DAY(DATE(CONCAT(vEndYear, '-', vEndMonth, '-01')));
	SET vTolerance = fGetTolerance();
	SET vHoursWorkday = fGetHoursWorkday();
	
    /** --- Creacion de total de registros de la tabla temportal --- */
	WHILE vCurrent <= vLast DO
		SET @vDynamicSQL = CONCAT('INSERT INTO tTemp(cStart, cEnd, cEmployeeKey, cEmployeeId, cEmployeeRut, cEmployeeName) SELECT ?, LAST_DAY(?), cKey, cId, cRut, cName FROM tEmployee WHERE cId IN (', vEmployees, ') ORDER BY cName;');

		SET @vCurrent = vCurrent;
		
		PREPARE smpt FROM @vDynamicSQL;
		EXECUTE smpt USING @vCurrent, @vCurrent;
		DEALLOCATE PREPARE smpt;

		SET vCurrent = DATE_ADD(vCurrent, INTERVAL 1 MONTH);
	END WHILE;
	
    /** --- Completitud de datos de las columnas de la tabla temportal --- */
	SET vI = 1;
	SELECT MAX(cId) INTO vMax FROM tTemp;  
	WHILE (vI <= vMax) DO
		SELECT
			cEmployeeId, cEmployeeKey, cStart, cEnd INTO vEmployeeId, vEmployeeKey, vFirstMonth, vLastMonth
		FROM	tTemp
		WHERE	cId = vI;
		
		SET vBusinessDayCount := 0;
		SET vMarkCount := 0;
		SET vDelayCount := 0;
		SET vExtraTimeAM := 0;
		SET vExtraTimePM := 0;
		SET vCurrent = vFirstMonth;
		WHILE vCurrent <= vLastMonth DO
			SET vFlexible := fIsFlexible(vCurrent, vEmployeeId); 
			IF(vFlexible IS NULL OR vFlexible = TRUE) THEN
				DELETE FROM tTemp WHERE cId = vI;
				SET vCurrent = vLastMonth;
			ELSE
				SET vTurnDayId := fMarkAndUserToTurnDayId4(vCurrent, vEmployeeId, vTolerance, FALSE);				
				SET vBusinessDay := fIsBusinessDay(vTurnDayId);
				SET vHoliday := fIsHoliday(vCurrent);

				SET vStartMark = fStartMark(vEmployeeKey, vTolerance, vCurrent, vBusinessDay, FALSE, vTurnDayId);
				SET vStartTime = fStartTime(vStartMark, vBusinessDay, vTurnDayId);				
				SET vStartDiffI = fExtraTimeAsMins6(vStartMark, vStartTime, TRUE, vTurnDayId);
				SET vStartDiffI = IFNULL(vStartDiffI, 0);

				SET vEndMark = fEndMark(vEmployeeKey, vStartMark, vHoursWorkday, vCurrent, vTolerance, vBusinessDay, vTurnDayId);
				SET vEndTime = fEndTime(vEndMark, vStartMark, vBusinessDay, vTurnDayId);
				SET vEndDiffI = fExtraTimeAsMins6(vEndMark, vEndTime, FALSE, vTurnDayId);
				SET vEndDiffI = IFNULL(vEndDiffI, 0);
				
				IF(vBusinessDay AND NOT vHoliday) THEN
					SET vBusinessDayCount = vBusinessDayCount + 1;
				END IF;
				
				IF(NOT vStartMark IS NULL AND NOT vEndMark IS NULL) THEN /* Si Tiene marca de entrada y de salida, suma uno */
					SET vMarkCount := vMarkCount + 1;
				END IF;

				IF(NOT vStartMark IS NULL) THEN
					SET vStartMarkCount = vStartMarkCount + 1;
				END IF;
				
				IF(vStartDiffI<=0 AND NOT vStartMark IS NULL) THEN
					SET vDelayCount := vDelayCount + 1;
				END IF;
				
				SET vExtraTimeAM := vExtraTimeAM + vStartDiffI;
				SET vExtraTimePM := vExtraTimePM + vEndDiffI;
				
			END IF;

			SET vCurrent = DATE_ADD(vCurrent, INTERVAL 1 DAY);
		END WHILE;
		
		UPDATE tTemp SET 
			cBusinessDayCount = vBusinessDayCount,
			cMarkCount = vMarkCount,
			cDelayCount = vDelayCount,
			cStartMarkCount = vStartMarkCount,
			cExtraTimeAM = vExtraTimeAM,
			cExtraTimePM = vExtraTimePM
		WHERE cId = vI;
		
		SET vI = vI + 1;
	END WHILE;
	
    /** --- Despliegue de las diferentes tablas --- */
	SET vCurrent = DATE(CONCAT(vStartYear, '-', vStartMonth, '-01'));
	WHILE vCurrent <= vLast DO
		SELECT	cStart											AS 'Inicio', 
				cEnd											AS 'Termino',
				cEmployeeRut									AS 'Rut Empleado',
				cEmployeeName									AS 'Nombre Empleado',
#				cBusinessDayCount								AS 'Total Marcas',
				CONCAT(cMarkCount, '/', cBusinessDayCount)		AS 'Marcas realizadas',
				ROUND((cMarkCount*100)/cBusinessDayCount, 0)	AS '% Asistencia',
				cDelayCount										AS 'Atrasos',
				ROUND((cDelayCount*100)/cStartMarkCount, 0)		AS '% Atrasos',
				cExtraTimeAM									AS 'Minutos Extras AM',
				cExtraTimePM									AS 'Minutos Extras PM'
		FROM tTemp 
		WHERE cStart = vCurrent;
		
		SET vCurrent = DATE_ADD(vCurrent, INTERVAL 1 MONTH);
	END WHILE;

	/*
	select '-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+';
	select * from tTemp;
	select vFirst, vLast;	
*/
	DROP TEMPORARY TABLE IF EXISTS tTemp;
END$$

/****************************************************************/
DROP FUNCTION IF EXISTS fIsBusinessDay;
CREATE FUNCTION fIsBusinessDay(vTurnDayId BIGINT(20)) RETURNS BOOLEAN
BEGIN
	DECLARE vOut BOOLEAN;
	SELECT cBusinessDay INTO vOut FROM tTurnDay WHERE cId = vTurnDayId;
	RETURN vOut;
END$$

/****************************************************************/
DROP FUNCTION IF EXISTS fIsHoliday;
CREATE FUNCTION fIsHoliday(vCurrent DATE) RETURNS BOOLEAN
BEGIN
	DECLARE vOut BOOLEAN;
	DECLARE vDayOfWeek	INTEGER;
	SET vDayOfWeek := DAYOFWEEK(vCurrent);
	SET vOut := EXISTS(SELECT cId FROM tFiscalDate WHERE cDate = DATE(vCurrent)) OR vDayOfWeek=1 OR vDayOfWeek=7;
	RETURN vOut;
END$$

DELIMITER ;


