DROP PROCEDURE IF EXISTS pCrew;

DELIMITER $$

CREATE PROCEDURE pCrew(IN vStartDate DATE, IN vEndDate DATE, IN vEmployees VARCHAR(2500))
BEGIN
	DECLARE vCurrent DATE;
	
	SET @vStartDate = vStartDate;
	SET @vEndDate = vEndDate;
	
	DROP TABLE IF EXISTS tCrewProcess_temp;
	CREATE TABLE IF NOT EXISTS tCrewProcess_temp(
		cId				BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		cDate			DATE NOT NULL,
		cEmployee		BIGINT(20) NULL,
		cHoursWorked	DOUBLE DEFAULT '0',
		cWorked			BIT	DEFAULT 0,
		cHired			BIT DEFAULT 0
	) ENGINE=Memory;
	
	SET @vSQL = 'INSERT INTO tCrewProcess_temp(cDate, cEmployee, cHoursWorked, cWorked, cHired) ';
	SET @vSQL = CONCAT(@vSQL, 'SELECT cDate, cEmployee, cHoursWorked, cWorked, cHired ');
	SET @vSQL = CONCAT(@vSQL, 'FROM tCrewProcess ');
	SET @vSQL = CONCAT(@vSQL, 'WHERE DATE(cDate) BETWEEN ? AND ? ');
#	SET @vSQL = CONCAT(@vSQL, 'AND cEmployee IN (', vEmployees,') ');
	SET @vSQL = CONCAT(@vSQL, ';');
#	SET @vSQL = CONCAT(@vSQL, 'ORDER BY	cDate;');
	
	PREPARE smpt FROM @vSQL;
	EXECUTE smpt USING @vStartDate, @vEndDate;
	DEALLOCATE PREPARE smpt;
	
#select @vSQL;
#select distinct(cEmployee) from tCrewProcess_temp;

	SET vCurrent = vStartDate;
	WHILE vCurrent <= vEndDate DO
#select  (SELECT COUNT(cId) FROM tCrewProcess_temp WHERE DATE(cDate) = DATE(vCurrent)), vCurrent;
	
		IF(SELECT COUNT(cId) FROM tCrewProcess_temp WHERE DATE(cDate) = DATE(vCurrent)=0) THEN
			INSERT INTO tCrewProcess_temp(cDate, cEmployee, cHoursWorked, cWorked, cHired) VALUES(vCurrent, NULL, 0,FALSE,FALSE);
#			select 'inserted' ,vCurrent;
		END IF;
		SET vCurrent = DATE_ADD(vCurrent, INTERVAL 1 DAY);
	END WHILE;
	
	SET @vSQL = 'SELECT	cDate AS \'Fecha\', ROUND(SUM(cHoursWorked),2) AS \'Horas Trabajadas\', sum(if(cWorked, 1, 0)) AS \'Presente\', sum(if(cHired,1,0)) AS \'Contratados\', IFNULL( ROUND((sum(if(cWorked, 1, 0))*100)/sum(if(cHired,1,0)),2), 0) AS \'% Asistencia\' ';
#	SET @vSQL = 'SELECT	cDate, SUM(cHoursWorked), COUNT(cWorked), COUNT(cHired), (COUNT(cWorked)*100)/COUNT(cHired) ';
	SET @vSQL = CONCAT(@vSQL, 'FROM	tCrewProcess_temp AS a ');
	SET @vSQL = CONCAT(@vSQL, 'WHERE cEmployee IN (', vEmployees,') OR cEmployee IS NULL ');
	SET @vSQL = CONCAT(@vSQL, 'GROUP BY DATE(cDate);');


#select * from tCrewProcess_temp where cEmployee IN (2,31,69,78,174,176,211,269,279,362,372,450,513,516,664,688);
#select * from tCrewProcess_temp where date(cdate) = '2015-10-03';
#select @vSQL;
	
	PREPARE smpt FROM @vSQL;
	EXECUTE smpt; 
	# USING @vStartDate, @vEndDate;
	DEALLOCATE PREPARE smpt;
	
	DROP TABLE IF EXISTS tCrewProcess_temp;
	
END$$
