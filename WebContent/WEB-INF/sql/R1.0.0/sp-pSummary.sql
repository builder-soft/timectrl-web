DROP PROCEDURE if exists pSummary;
DELIMITER $$

CREATE PROCEDURE pSummary(IN vStartDate DATE, IN vEndDate DATE, IN vEmployee VARCHAR(10), IN vTurn VARCHAR(10))
BEGIN
	IF(vEmployee = '') THEN
		SELECT * 
		FROM tTimeCtrl 
		WHERE cDate BETWEEN vStartDate AND vEndDate AND cTurn = vTurn;
	ELSE
		SELECT * 
		FROM tTimeCtrl 
		WHERE cDate BETWEEN vStartDate AND vEndDate AND cEmployeeKey = vEmployee AND cTurn = vTurn;
	END IF;
END$$

DELIMITER ;
