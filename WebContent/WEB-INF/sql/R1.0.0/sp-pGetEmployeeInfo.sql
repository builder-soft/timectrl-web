DROP PROCEDURE if exists pGetEmployeeInfo;
DELIMITER $$

CREATE PROCEDURE pGetEmployeeInfo(IN vKey VARCHAR(25))
BEGIN
	SELECT	e.cId, e.cRut, e.cName, e.cPost, e.cArea, e.cPrivilege, 
			e.cUsername, a.cName AS cAreaName, a.cKey AS cCC,
			(	SELECT	t.cName
				FROM	tR_EmployeeTurn AS r
				LEFT JOIN tTurn AS t ON r.cTurn = t.cId
				WHERE	r.cEmployee = e.cId
				LIMIT 1
			) AS cTurnName,
			(	SELECT	CONCAT(t.cStartTime, ' - ', t.cEndTime) 
				FROM	tR_EmployeeTurn AS r
				LEFT JOIN tTurnDay AS t ON r.cTurn = t.cTurn
				WHERE	r.cEmployee = e.cId AND cDay = 1 
				LIMIT 1
			) AS cHorary
	FROM 	tEmployee AS e
	LEFT JOIN tArea AS a ON e.cArea = a.cId
	WHERE	e.cKey = vKey;
END$$

DELIMITER ;