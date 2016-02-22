DROP PROCEDURE if exists pIncorporateEmployee;

DELIMITER $$

CREATE PROCEDURE pIncorporateEmployee(IN vId BIGINT(20))
BEGIN
	UPDATE tEmployee SET cEnabled = TRUE WHERE cId=vId;
END$$

DELIMITER ;