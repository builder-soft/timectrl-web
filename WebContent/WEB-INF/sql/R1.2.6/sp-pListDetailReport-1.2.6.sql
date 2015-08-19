DROP PROCEDURE if exists pListDetailReport;
DELIMITER $$


CREATE PROCEDURE pListDetailReport(IN vBoss BIGINT(20), IN vEmployees VARCHAR(1000), IN vStartMonth INT, IN vStartYear INT, 
									IN vEndMonth INT, IN vEndYear INT)
BEGIN
	DECLARE vCommaPosition INTEGER DEFAULT 0;
	DECLARE vEmployee BIGINT(20);
	DECLARE vStart DATE;
	DECLARE vEnd DATE;
	
#	select CONCAT_WS('-', vStartYear, vStartMonth, '1');
	
	SET vStart = DATE_FORMAT(CONCAT_WS('-', vStartYear, vStartMonth, '1'), '%Y-%m-%d');
	SET vEnd = DATE_FORMAT(CONCAT_WS('-', vEndYear, vEndMonth, '1'), '%Y-%m-%d');
	SET vEnd = LAST_DAY(vEnd);
	
	WHILE (LENGTH(vEmployees)>0) DO
		SET vCommaPosition = INSTR(vEmployees, ',');
		
		IF(vCommaPosition=0) THEN
			SET vEmployee = CAST(vEmployees AS UNSIGNED);
			SET vEmployees = '';
		ELSE
			SET vEmployee = CAST(SUBSTR(vEmployees,1,vCommaPosition-1) AS UNSIGNED);
			SET vEmployees = RIGHT(vEmployees, LENGTH(vEmployees)-(LENGTH(vEmployee)+1));
		END IF;
		
#		select vEmployees, concat('-',vEmployee,'-');
		call pListAttendance3(vEmployee, vStart, vEnd);
	END WHILE;
	
#	call pListAttendance3(10, '2015-01-01', '2015-01-15');
#	call pListAttendance3(11, '2015-01-01', '2015-01-15');
#	call pListAttendance3(12, '2015-01-01', '2015-01-15');
	
	
END$$

