DROP PROCEDURE IF EXISTS pAbsence;

DELIMITER $$

CREATE PROCEDURE pAbsence(IN vDate DATE)
BEGIN	
	DECLARE vId		BIGINT(20);
	DECLARE vKey 	VARCHAR(15);
	DECLARE vDone BOOLEAN DEFAULT FALSE;
	DECLARE cursorEmployee CURSOR FOR
		SELECT	cId, cKey
		FROM	tEmployee
		WHERE 	cEnabled=TRUE;		
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET vDone = TRUE;
	
	DROP TEMPORARY TABLE IF EXISTS tEmployee_temp;
	
	CREATE TEMPORARY TABLE tEmployee_temp (
		idEmployee BIGINT(20)  NOT NULL
    )Engine=memory;
	
	OPEN cursorEmployee;
	cursorEmployee_loop: LOOP
		FETCH cursorEmployee INTO vId, vKey;
		
		IF(vDone) THEN 
			LEAVE cursorEmployee_loop;
		END IF;

		IF NOT EXISTS(SELECT cDate FROM tAttendanceLog WHERE vDate = DATE(cDate) AND cEmployeeKey = vKey) THEN 
		    INSERT INTO tEmployee_temp(idEmployee) VALUES(vId);
		END IF;
		
	END LOOP cursorEmployee_loop;
	CLOSE cursorEmployee;
	
	SELECT	a.cId			AS 'Id Empleado',
			a.cRut			AS 'RUT',
			a.cName			AS 'Nombre',
			c.cName			AS 'Cargo',
			b.cName			AS 'Area',
		IFNULL(	(SELECT CONCAT(cStartTime, ' A ', cEndTime) 
				FROM tTurnDay 
				WHERE cId = fMarkAndUserToTurnDayId4(vDate, a.cId, fGetTolerance(), fIsFlexible(vDate, a.cId))),'Sin Turno') AS 'Turno'
	FROM tEmployee AS a
	LEFT JOIN tArea AS b ON a.cArea = b.cId
	LEFT JOIN tPost AS c ON a.cPost = c.cId
	WHERE a.cId IN (SELECT idEmployee FROM tEmployee_temp)
	ORDER BY a.cName;
	
	DROP TEMPORARY TABLE IF EXISTS tEmployee_temp;
	
END$$

DELIMITER ;
