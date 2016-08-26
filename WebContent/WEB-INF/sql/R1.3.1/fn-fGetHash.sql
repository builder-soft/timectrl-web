DROP FUNCTION IF EXISTS fGetHash;

DELIMITER $$

CREATE FUNCTION fGetHash(vEmployeeKey varchar(15), vMachine bigint(20), vDate timestamp, vMarkType bigint(20)) RETURNS VARCHAR(32)
BEGIN
	DECLARE vOut VARCHAR(32);
	
	SET vOut = md5(concat(vEmployeeKey,'#',vMachine,'#',vDate,'#',vMarkType));
	
	RETURN vOut;
END$$

DELIMITER ;
	