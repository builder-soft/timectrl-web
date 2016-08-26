DROP PROCEDURE if exists bsframework.pSaveUser;
DELIMITER $$

CREATE PROCEDURE bsframework.pSaveUser(IN pId BIGINT, IN pMail VARCHAR(50), 
	IN pName VARCHAR(100), IN pDomain BIGINT)
BEGIN
	IF EXISTS(	SELECT	cId 
				FROM	bsframework.tUser
				WHERE	cId = pId) THEN

		UPDATE	bsframework.tUser
		SET		cMail = pMail,
				cName = pName
		WHERE	cId = pId;

		SELECT pId AS cId;
	ELSE
		INSERT INTO bsframework.tUser(cMail, cName, cAdmin) 
		VALUES(pMail, pName, false);

		INSERT INTO tr_userdomain(cUser, cDomain) VALUES(LAST_INSERT_ID(), pDomain); 

		SELECT LAST_INSERT_ID() AS cId;

	END IF;
END$$

DELIMITER ;
