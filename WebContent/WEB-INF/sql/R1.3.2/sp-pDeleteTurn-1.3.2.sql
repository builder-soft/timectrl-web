DROP PROCEDURE if exists pDeleteTurn;
DELIMITER $$

CREATE PROCEDURE pDeleteTurn(IN pId BIGINT)
BEGIN
	
	delete from tTurnDay where cTurn = pId;
	delete from tTurn where cId = pId;
END$$

DELIMITER ;
