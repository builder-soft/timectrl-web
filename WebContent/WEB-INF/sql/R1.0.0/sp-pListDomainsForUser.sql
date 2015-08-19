DROP PROCEDURE if exists bsframework.pListDomainsForUser;
DELIMITER $$

CREATE PROCEDURE bsframework.pListDomainsForUser(IN user BIGINT)
BEGIN
	SELECT		d.cId 
	FROM 		bsframework.tDomain AS d
	LEFT JOIN	tR_UserDomain AS r ON r.cDomain = d.cId
	WHERE		r.cUser = user;
END$$

DELIMITER ;

/*
call bsframework.getDomainsForUser(1);
*/

