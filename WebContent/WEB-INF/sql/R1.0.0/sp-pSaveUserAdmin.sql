DROP PROCEDURE if exists bsframework.pSaveUserAdmin;
DELIMITER $$

CREATE PROCEDURE bsframework.pSaveUserAdmin(IN pId BIGINT, IN pMail VARCHAR(50), 
	IN pName VARCHAR(100), IN pAdmin BIT)
BEGIN

	IF EXISTS(	SELECT	cId 
				FROM	bsframework.tUser
				WHERE	cId = pId) THEN

		UPDATE	bsframework.tUser
		SET		cMail = pMail,
				cName = pName,
				cAdmin= pAdmin
		WHERE	cId = pId;
		
		SELECT pId AS cId;
	ELSE
		INSERT INTO bsframework.tUser(cMail, cName, cAdmin) 
		VALUES(pMail, pName, pAdmin);
		
		SELECT LAST_INSERT_ID() AS cId;
		
	END IF;
END$$

DELIMITER ;
