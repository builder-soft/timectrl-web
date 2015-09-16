DROP PROCEDURE IF EXISTS pTopAbsence;

DELIMITER $$

CREATE PROCEDURE pTopAbsence(IN vStartDate DATE, IN vEndDate DATE, IN vTop INTEGER)
BEGIN
	DECLARE vId		BIGINT(20);
	DECLARE vKey 	VARCHAR(15);
	DECLARE vDone BOOLEAN DEFAULT FALSE;
	DECLARE cursorEmployee CURSOR FOR
		SELECT	cId, cKey
		FROM	tEmployee;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET vDone = TRUE;
	
	DROP TEMPORARY TABLE IF EXISTS tEmployee_temp;
	
	CREATE TEMPORARY TABLE tEmployee_temp (
		idEmployee		BIGINT(20)  NOT NULL,
		absenceCount	INTEGER DEFAULT '0'
    )Engine=memory;
	
	OPEN cursorEmployee;
	cursorEmployee_loop: LOOP
		FETCH cursorEmployee INTO vId, vKey;
		
		IF(vDone) THEN 
			LEAVE cursorEmployee_loop;
		END IF;

		IF NOT EXISTS(SELECT cDate FROM tAttendanceLog WHERE DATE(cDate) BETWEEN vStartDate AND vEndDate AND cEmployeeKey = vKey) THEN
			
		    INSERT INTO tEmployee_temp(idEmployee, absenceCount) 
		    	VALUES(vId, 
		    		(SELECT count(cId) FROM tAttendanceLog WHERE cEmployeeKey = vKey)
		    	
		    	);
		END IF;
		
	END LOOP cursorEmployee_loop;
	CLOSE cursorEmployee;
	
	
	
	/**
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
	
	*/
	select * from tEmployee_temp order by absenceCount;
	
	DROP TEMPORARY TABLE IF EXISTS tEmployee_temp;
END$$

DELIMITER ;
