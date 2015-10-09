DROP PROCEDURE IF EXISTS pCrew;

DELIMITER $$

CREATE PROCEDURE pCrew(IN vStartDate DATE, IN vEndDate DATE, IN vEmployees VARCHAR(2000))
BEGIN
	SELECT a.* 
	FROM tAttendanceLog AS a
	LEFT JOIN tEmployee AS b ON a.cEmployeeKey = b.cKey
	WHERE DATE(a.cDate) BETWEEN vStartDate AND vEndDate
		AND b.cId = vEmployees;
	
	
END$$