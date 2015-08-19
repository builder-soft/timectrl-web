DROP PROCEDURE if exists pOvertime;
DELIMITER $$

CREATE PROCEDURE pOvertime(IN vMonth INTEGER, IN vYear INTEGER, IN vArea BIGINT(20))
BEGIN
	/**
	 * Este SP debe traer todos los empleados de un área especificada, 
	 * entregando las horas extras que hizo cada uno durante el mes.
	 * */
	
	CREATE TEMPORARY TABLE tOvertime_temp(
		cId			BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		cEmployeeId	BIGINT(20) NOT NULL,
		
		cKey		VARCHAR(25),
		cRut		VARCHAR(11),
		cName		VARCHAR(50),
		
		cOvertimeI	INTEGER,
		cOvertimeM	VARCHAR(9)
    ) Engine=memory;
	
	INSERT	INTO tOvertime_temp(cEmployeeId, cKey, cRut, cName)
	SELECT	cId, cKey, cRut, cName
	FROM	tEmployee
	WHERE	cKey IN (SELECT DISTINCT(cEmployeeKey) 
					FROM tAttendanceLog 
					WHERE MONTH(cDate) = vMonth AND YEAR(cDate) = vYear) AND cArea = vArea;
					
	SELECT * FROM tAttendanceLog 
	WHERE MONTH(cDate) = vMonth AND YEAR(cDate) = vYear AND cEmployeeKey = '299';
					
/*
	SELECT	cEmployeeKey, count(cEmployeeKey)
	FROM	tAttendanceLog
	WHERE	MONTH(cDate) = vMonth AND YEAR(cDate) = vYear AND cEmployeeKey IN (SELECT cKey FROM tEmployee WHERE cArea = vArea)
	GROUP BY cEmployeeKey;
*/
	
	SELECT * FROM tOvertime_temp;
	DROP TEMPORARY TABLE tOvertime_temp;
	
END$$
DELIMITER ;
