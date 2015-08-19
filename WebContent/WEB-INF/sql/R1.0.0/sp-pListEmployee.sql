DROP PROCEDURE if exists pListEmployee;
DELIMITER $$

CREATE PROCEDURE pListEmployee()
BEGIN
	SELECT	cId, cKey, cRut, cName, cPost, cArea, cPrivilege, cEnabled, cUsername 
	FROM 	tEmployee;
END$$

DELIMITER ;
