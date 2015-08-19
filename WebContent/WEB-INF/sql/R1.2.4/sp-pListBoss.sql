DROP PROCEDURE if exists pListBoss;
DELIMITER $$

CREATE PROCEDURE pListBoss()
BEGIN
	SELECT	cId, cKey, cRut, cName, cPost, cArea, cPrivilege, cEnabled, cUsername 
	FROM 	tEmployee
	WHERE	cId IN (SELECT DISTINCT(cBoss) FROM tEmployee WHERE NOT cBoss IS NULL);
END$$

DROP FUNCTION IF EXISTS fRec$$

DELIMITER ;

