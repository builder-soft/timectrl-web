DROP PROCEDURE if exists pHoursWorked;
DELIMITER $$

CREATE PROCEDURE pHoursWorked(IN vStartDate DATE, IN vEndDate DATE)
BEGIN
	
	select * from tEmployee limit 10;
	
END$$

DELIMITER ;