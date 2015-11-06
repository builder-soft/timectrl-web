DROP PROCEDURE if exists pListCorrectedTime;
DELIMITER $$


CREATE PROCEDURE pListCorrectedTime(IN vEmployees VARCHAR(2500), IN vMonth INT, IN vYear INT)
BEGIN
	DECLARE vCommaPosition INTEGER DEFAULT 0;
	DECLARE vEmployee BIGINT(20);
	DECLARE vStart DATE;
	DECLARE vEnd DATE;
	
	SET vStart = DATE_FORMAT(CONCAT_WS('-', vYear, vMonth, '1'), '%Y-%m-%d');
#	SET vEnd = DATE_FORMAT(CONCAT_WS('-', vEndYear, vEndMonth, '1'), '%Y-%m-%d');
	SET vEnd = LAST_DAY(vStart);
	
	WHILE (LENGTH(vEmployees)>0) DO
		SET vCommaPosition = INSTR(vEmployees, ',');
		
		IF(vCommaPosition=0) THEN
			SET vEmployee = CAST(vEmployees AS UNSIGNED);
			SET vEmployees = '';
		ELSE
			SET vEmployee = CAST(SUBSTR(vEmployees,1,vCommaPosition-1) AS UNSIGNED);
			SET vEmployees = RIGHT(vEmployees, LENGTH(vEmployees)-(LENGTH(vEmployee)+1));
		END IF;
		
		call pListAttendance4(vEmployee, vStart, vEnd);
	END WHILE;
		
END$$

