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

		#IF NOT EXISTS(SELECT cDate FROM tAttendanceLog WHERE DATE(cDate) BETWEEN vStartDate AND vEndDate AND cEmployeeKey = vKey) THEN
		
		SET vCount = 0;
		SET vCurrent = vStartDate;
		WHILE vCurrent < vEndDate DO
#select 1;
#			SELECT count(cId) INTO vCountTemp
#			FROM tAttendanceLog 
#			WHERE DATE(vCurrent) = DATE(cDate) AND cEmployeeKey = vKey;
			
#			IF (vCountTemp = 0) THEN
#				SET vCount = vCount + 1;
#			END IF;
			
			IF NOT EXISTS(SELECT cId FROM tAttendanceLog WHERE DATE(vCurrent) = DATE(cDate) AND cEmployeeKey = vKey) THEN
				SET vCount = vCount + 1;
			END IF;

#			select vCount ;

			SET vCurrent = DATE_ADD(vCurrent, INTERVAL 1 DAY);
		END WHILE;
				
	    INSERT INTO tEmployee_temp(idEmployee, absenceCount) 
	    	VALUES(vId, vCount);
		#END IF;
		
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

#	select * from tEmployee_temp order by idEmployee;

#	select * from tAttendanceLog where DATE(cDate) BETWEEN vStartDate AND vEndDate;

#select count(a.ckey) # a.cid, a.ckey, b.*
#from tEmployee AS a LEFT JOIN tAttendanceLog AS b ON a.cKey = b.cEmployeeKey and b.cDate = null
#group by a.ckey
#order by a.cId;

#select count(*) from tEmployee;

	DROP TEMPORARY TABLE IF EXISTS tEmployee_temp;
END$$

DELIMITER ;
