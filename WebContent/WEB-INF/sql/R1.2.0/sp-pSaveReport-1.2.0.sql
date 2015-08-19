DROP PROCEDURE if exists pSaveReport;
DELIMITER $$

CREATE PROCEDURE pSaveReport(IN vKey VARCHAR(20), IN vName VARCHAR(50), IN vType BIGINT(20))
BEGIN
	DECLARE vId BIGINT(20);
	INSERT INTO tReport(cKey, cName, cType) VALUES(vKey, vName, vType);
	
	SET vId = LAST_INSERT_ID();
	
	INSERT INTO tReportOutValue(cParam, cReport, cValue)
		SELECT cId, vId, '' FROM tReportOutParam WHERE cReportType=vType;
	
	SELECT vId;
	
END$$

DELIMITER ;