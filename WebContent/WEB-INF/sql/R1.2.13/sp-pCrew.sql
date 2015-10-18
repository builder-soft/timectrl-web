DROP PROCEDURE IF EXISTS pCrew;

DELIMITER $$

CREATE PROCEDURE pCrew(IN vStartDate DATE, IN vEndDate DATE, IN vEmployees VARCHAR(2500))
BEGIN
	SET @vSQL = 'SELECT	cDate AS \'Fecha\', ROUND(SUM(cHoursWorked),2) AS \'Horas Trabajadas\', sum(if(cWorked, 1, 0)) AS \'Presente\', sum(if(cHired,1,0)) AS \'Contratados\', ROUND((sum(if(cWorked, 1, 0))*100)/sum(if(cHired,1,0)),2) AS \'% Asistencia\' ';
#	SET @vSQL = 'SELECT	cDate, SUM(cHoursWorked), COUNT(cWorked), COUNT(cHired), (COUNT(cWorked)*100)/COUNT(cHired) ';
	SET @vSQL = CONCAT(@vSQL, 'FROM	tCrewProcess AS a ');
	SET @vSQL = CONCAT(@vSQL, 'WHERE	DATE(cDate) BETWEEN ? AND ? ');
	SET @vSQL = CONCAT(@vSQL, 'AND cEmployee IN (', vEmployees ,')');
	SET @vSQL = CONCAT(@vSQL, 'GROUP BY cDate;');

	SET @vStartDate = vStartDate;
	SET @vEndDate = vEndDate;
	
	PREPARE smpt FROM @vSQL;
	EXECUTE smpt USING @vStartDate, @vEndDate;
	DEALLOCATE PREPARE smpt;
END$$
