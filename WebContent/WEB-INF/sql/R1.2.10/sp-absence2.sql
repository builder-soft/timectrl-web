DROP PROCEDURE IF EXISTS pAbsence2;

DELIMITER $$

CREATE PROCEDURE pAbsence2(IN vStartDate DATE, IN vEndDate DATE, IN vEmployees VARCHAR(2000))
BEGIN
	DECLARE vId		BIGINT(20);
	DECLARE vKey 	VARCHAR(15);
	DECLARE vCurrent	DATE;
	DECLARE vDone BOOLEAN DEFAULT FALSE;
	#DECLARE @vSQL	VARCHAR(3000);
	DECLARE cursorEmployee CURSOR FOR
		SELECT	cId, cKey
		FROM	tEmployee;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET vDone = TRUE;
	
	DROP TEMPORARY TABLE IF EXISTS tEmployee_temp;
	
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

		SET vCurrent = vStartDate;
		WHILE vCurrent < vEndDate DO
			
			IF NOT EXISTS(SELECT cId FROM tAttendanceLog WHERE DATE(vCurrent) = DATE(cDate) AND cEmployeeKey = vKey) THEN
				INSERT INTO tEmployee_temp(idEmployee, absenceDate) VALUES(vId, DATE(vCurrent));
			END IF;

			SET vCurrent = DATE_ADD(vCurrent, INTERVAL 1 DAY);
		END WHILE;
		
	END LOOP cursorEmployee_loop;
	CLOSE cursorEmployee;
	
	
	SET @vSQL = 'SELECT b.cId			AS cId, ';
	SET @vSQL = CONCAT(@vSQL, 'b.cRut			AS cEmployeeRut, ');
	SET @vSQL = CONCAT(@vSQL, 'b.cName			AS cEmployeeName, ');
	SET @vSQL = CONCAT(@vSQL, 'c.cName			AS cEmployeePost, ');
	SET @vSQL = CONCAT(@vSQL, 'd.cName			AS cEmployeeArea, ');
	SET @vSQL = CONCAT(@vSQL, 'a.absenceDate	AS cAbsenceDate, ');
	SET @vSQL = CONCAT(@vSQL, 'fGetLicenseCause(a.absenceDate, b.cId) AS cCause ');
	SET @vSQL = CONCAT(@vSQL, 'FROM tEmployee_temp AS a ');
	SET @vSQL = CONCAT(@vSQL, 'LEFT JOIN tEmployee AS b ON a.idEmployee = b.cId ');
	SET @vSQL = CONCAT(@vSQL, 'LEFT JOIN tPost AS c ON b.cPost = c.cId ');
	SET @vSQL = CONCAT(@vSQL, 'LEFT JOIN tArea AS d ON b.cArea = d.cId ');
	SET @vSQL = CONCAT(@vSQL, 'WHERE b.cId IN (',vEmployees,') ');
	SET @vSQL = CONCAT(@vSQL, 'ORDER BY b.cName DESC; ');

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
			vDate BETWEEN cStartDate AND cEndDate;
 
	RETURN vOut;
END$$

DELIMITER ;
