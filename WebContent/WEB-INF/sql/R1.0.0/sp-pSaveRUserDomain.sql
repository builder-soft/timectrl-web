DROP PROCEDURE if exists bsframework.pSaveRUserDomain;
DELIMITER $$

CREATE PROCEDURE bsframework.pSaveRUserDomain(IN pUserId BIGINT, IN pDomainId BIGINT)
BEGIN
	IF NOT EXISTS(	SELECT	cUser 
				FROM	bsframework.tR_UserDomain
				WHERE	cUser = pUserId AND cDomain = pDomainId) THEN
				
		INSERT INTO bsframework.tR_UserDomain(cUser, cDomain) 
		VALUES(pUserId, pDomainId);
		
	END IF;
END$$

DELIMITER ;
