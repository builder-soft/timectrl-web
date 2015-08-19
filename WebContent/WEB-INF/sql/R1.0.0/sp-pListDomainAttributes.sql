DROP PROCEDURE if exists bsframework.pListDomainAttributes;
DELIMITER $$

CREATE PROCEDURE bsframework.pListDomainAttributes(IN domain BIGINT)
BEGIN
	SELECT		da.cId /*, da.cKey, da.cName, da.cValue*/
	FROM 		bsframework.tDomainAttribute AS da
	WHERE		da.cDomain = domain;
END$$

DELIMITER ;

/*
call bsframework.getDomainAttribute(1);
*/
