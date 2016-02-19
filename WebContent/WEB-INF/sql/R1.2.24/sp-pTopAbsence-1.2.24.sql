DROP PROCEDURE IF EXISTS pTopAbsence;

DELIMITER $$

CREATE PROCEDURE pTopAbsence(IN vStartDate DATE, IN vEndDate DATE, IN vTop INTEGER)
BEGIN
	DECLARE vId		BIGINT(20);
	DECLARE vKey 	VARCHAR(15);
	DECLARE vCurrent	DATE;
	DECLARE vCount	INTEGER;
	DECLARE vCountTemp	INTEGER;
	DECLARE vDone BOOLEAN DEFAULT FALSE;
	DECLARE cursorEmployee CURSOR FOR
		SELECT	cId, cKey
		FROM	tEmployee
		WHERE cEnabled=TRUE;
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
		
		SET vCount = 0;
		SET vCurrent = vStartDate;
		WHILE vCurrent <= vEndDate DO			
			IF NOT EXISTS(SELECT cId FROM tAttendanceLog WHERE DATE(vCurrent) = DATE(cDate) AND cEmployeeKey = vKey) AND fGetBusinessDay(vId, vKey, 180, vCurrent) THEN
				SET vCount = vCount + 1;
			END IF;

			SET vCurrent = DATE_ADD(vCurrent, INTERVAL 1 DAY);
		END WHILE;
				
	    INSERT INTO tEmployee_temp(idEmployee, absenceCount) 
	    	VALUES(vId, vCount);
		#END IF;
		
	END LOOP cursorEmployee_loop;
	CLOSE cursorEmployee;
	
	SELECT b.cId			AS cId,
			b.cRut			AS cEmployeeRut,
			b.cName			AS cEmployeeName,
			c.cName			AS cEmployeePost,
			d.cName			AS cEmployeeArea,
			a.absenceCount	AS cAbsenceCount		
	FROM tEmployee_temp AS a
		LEFT JOIN tEmployee AS b ON a.idEmployee = b.cId
		LEFT JOIN tPost AS c ON b.cPost = c.cId
		LEFT JOIN tArea AS d ON b.cArea = d.cId
	ORDER BY absenceCount DESC 
	LIMIT vTop;

	DROP TEMPORARY TABLE IF EXISTS tEmployee_temp;
END$$

DELIMITER ;
