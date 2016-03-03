DROP PROCEDURE if exists pDeleteEmployee;

DELIMITER $$

CREATE PROCEDURE pDeleteEmployee(IN vId BIGINT(20))
BEGIN
	UPDATE tEmployee SET cEnabled = FALSE WHERE cId=vId;
END$$

DELIMITER ;