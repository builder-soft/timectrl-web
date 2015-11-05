DROP PROCEDURE IF EXISTS pAbsence2;

DELIMITER $$

CREATE PROCEDURE pAbsence2(IN vStartDate DATE, IN vEndDate DATE, IN vEmployees VARCHAR(3000))
BEGIN
	DECLARE vId		BIGINT(20);
	DECLARE vKey 	VARCHAR(15);
	DECLARE vCurrent	DATE;
	DECLARE vDone 		BOOLEAN DEFAULT FALSE;
	DECLARE vFlexible	BOOLEAN;
	DECLARE vBusinessDay	BOOLEAN;
	DECLARE vTolerance	INTEGER;
	DECLARE cursorEmployee CURSOR FOR
		SELECT	cId, cKey
		FROM	tEmployee;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET vDone = TRUE;
	
	DROP TEMPORARY TABLE IF EXISTS tEmployee_temp;
	
	SET vTolerance = fGetTolerance();
	
	CREATE TEMPORARY TABLE tEmployee_temp (
		idEmployee		BIGINT(20)  NOT NULL,
		absenceDate		DATE NOT NULL
    )Engine=memory;
	
	OPEN cursorEmployee;
	cursorEmployee_loop: LOOP
		FETCH cursorEmployee INTO vId, vKey;
		
		IF(vDone) THEN 
			LEAVE cursorEmployee_loop;
		END IF;

#select vCurrent, vId;
		
		SET vCurrent = vStartDate;
		WHILE vCurrent <= vEndDate DO
			
			IF NOT EXISTS(SELECT cId FROM tAttendanceLog WHERE DATE(vCurrent) = DATE(cDate) AND cEmployeeKey = vKey) THEN
				IF(NOT EXISTS(SELECT cId FROM tFiscalDate WHERE cDate = DATE(vCurrent))) THEN
#select vCurrent, vId, 'isFlex';
					SET vFlexible = fIsFlexible(vCurrent, vId);
#select vCurrent, vId, 'isBusinessDay';
					SET vBusinessDay = fGetBusinessDay(vId, vKey, vTolerance, vCurrent);
#select 'done';
					IF(vBusinessDay) THEN
						INSERT INTO tEmployee_temp(idEmployee, absenceDate) VALUES(vId, DATE(vCurrent));
					END IF;
				END IF;
			END IF;

			SET vCurrent = DATE_ADD(vCurrent, INTERVAL 1 DAY);
		END WHILE;
		
	END LOOP cursorEmployee_loop;
	CLOSE cursorEmployee;
	
	
	SET @vSQL = 'SELECT b.cId			AS Id, ';
	SET @vSQL = CONCAT(@vSQL, 'a.absenceDate	AS Fecha, ');
	SET @vSQL = CONCAT(@vSQL, 'b.cRut			AS Rut, ');
	SET @vSQL = CONCAT(@vSQL, 'b.cName			AS Nombre, ');
	SET @vSQL = CONCAT(@vSQL, 'c.cName			AS Cargo, ');
	SET @vSQL = CONCAT(@vSQL, 'd.cName			AS Area, ');
	SET @vSQL = CONCAT(@vSQL, 'fGetLicenseCause(a.absenceDate, b.cId) AS Causa ');
	SET @vSQL = CONCAT(@vSQL, 'FROM tEmployee_temp AS a ');
	SET @vSQL = CONCAT(@vSQL, 'LEFT JOIN tEmployee AS b ON a.idEmployee = b.cId ');
	SET @vSQL = CONCAT(@vSQL, 'LEFT JOIN tPost AS c ON b.cPost = c.cId ');
	SET @vSQL = CONCAT(@vSQL, 'LEFT JOIN tArea AS d ON b.cArea = d.cId ');
	SET @vSQL = CONCAT(@vSQL, 'WHERE b.cId IN (',vEmployees,') ');
	SET @vSQL = CONCAT(@vSQL, 'ORDER BY a.absenceDate, b.cName ; ');

#	select @vSQL;
		PREPARE smpt FROM @vSQL;
		EXECUTE smpt; # USING @vCurrent, @vCurrent;
		DEALLOCATE PREPARE smpt;
	
	
	DROP TEMPORARY TABLE IF EXISTS tEmployee_temp;
END$$

DROP FUNCTION IF EXISTS fGetLicenseCause;
CREATE FUNCTION fGetLicenseCause(vDate DATE, vEmployeeId BIGINT(20)) RETURNS CHAR(30)
BEGIN
	DECLARE vOut VARCHAR(120) DEFAULT 'Sin Justificar';
 
 	SELECT tLicenseCause.cName INTO vOut 
	FROM tLicense 
	LEFT JOIN tLicenseCause ON tLicense.cLicenseCause = tLicenseCause.cId 
	WHERE	cEmployee = vEmployeeId AND 
			vDate BETWEEN cStartDate AND cEndDate
	LIMIT 1;
 
	RETURN vOut;
END$$

DELIMITER ;
