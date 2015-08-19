DROP PROCEDURE IF EXISTS pAbsence;

DELIMITER $$

CREATE PROCEDURE pAbsence(IN vDate DATE)
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
		idEmployee BIGINT(20)  NOT NULL
    );
	
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
	
	SELECT	e.cId							AS 'Id Empleado',
			e.cRut							AS 'RUT',
			e.cName							AS 'Nombre', 
			a.cName							AS 'Area'
	FROM tEmployee AS e
	LEFT JOIN tArea AS a ON e.cArea = a.cId
	WHERE e.cId IN (SELECT idEmployee FROM tEmployee_temp)
	ORDER BY e.cName;
	
END$$

DELIMITER ;
