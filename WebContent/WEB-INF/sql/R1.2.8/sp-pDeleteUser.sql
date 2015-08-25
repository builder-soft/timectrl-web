DROP PROCEDURE if exists bsframework.pDelUser;
DROP PROCEDURE if exists pDeleteUser;

DELIMITER $$

CREATE PROCEDURE pDeleteUser(IN vId BIGINT(20))
BEGIN
	DELETE FROM tR_UserRol WHERE cUser=vId;
	DELETE FROM bsframework.tR_UserDomain WHERE cUser=vId;
	DELETE FROM bsframework.tUser WHERE cId=vId;
END$$

DELIMITER ;