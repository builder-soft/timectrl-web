DROP PROCEDURE IF EXISTS pCrew;

DELIMITER $$

CREATE PROCEDURE pCrew(IN vStartDate DATE, IN vEndDate DATE, IN vEmployees VARCHAR(2500))
BEGIN
	DROP TABLE IF EXISTS tCrewProcess_temp;
	CREATE TABLE IF NOT EXISTS tCrewProcess_temp(
		cId				BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		cDate			DATE NOT NULL,
		cEmployee		BIGINT NOT NULL,
		cHoursWorked	DOUBLE DEFAULT '0',
		cWorked			BIT	DEFAULT 0,
		cHired			BIT DEFAULT 0
	) ENGINE=Memory;
	
	INSERT INTO	tCrewProcess_temp(cDate, cEmployee, cHoursWorked, cWorked, cHired)
	SELECT		cDate, cEmployee, cHoursWorked, cWorked, cHired
	FROM		tCrewProcess 
	WHERE		DATE(cDate) BETWEEN vStartDate AND vEndDate
	ORDER BY	cDate;
	
	SET @vSQL = 'SELECT	cDate AS \'Fecha\', ROUND(SUM(cHoursWorked),2) AS \'Horas Trabajadas\', sum(if(cWorked, 1, 0)) AS \'Presente\', sum(if(cHired,1,0)) AS \'Contratados\', IFNULL( ROUND((sum(if(cWorked, 1, 0))*100)/sum(if(cHired,1,0)),2), 0) AS \'% Asistencia\' ';
#	SET @vSQL = 'SELECT	cDate, SUM(cHoursWorked), COUNT(cWorked), COUNT(cHired), (COUNT(cWorked)*100)/COUNT(cHired) ';
	SET @vSQL = CONCAT(@vSQL, 'FROM	tCrewProcess_temp AS a ');
	SET @vSQL = CONCAT(@vSQL, 'WHERE cEmployee IN (', vEmployees,') ');
	SET @vSQL = CONCAT(@vSQL, 'GROUP BY cDate;');

	SET @vStartDate = vStartDate;
	SET @vEndDate = vEndDate;

	select @vSQL;
	
	PREPARE smpt FROM @vSQL;
	EXECUTE smpt; 
	# USING @vStartDate, @vEndDate;
	DEALLOCATE PREPARE smpt;
	
	DROP TABLE IF EXISTS tCrewProcess_temp;
	
END$$
