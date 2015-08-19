DROP PROCEDURE if exists pSaveReport;
DELIMITER $$

CREATE PROCEDURE pSaveReport(IN vKey VARCHAR(20), IN vName VARCHAR(50), IN vType BIGINT(20))
BEGIN
	DECLARE vId BIGINT(20);
	INSERT INTO tReport(cKey, cName, cType) VALUES(vKey, vName, vType);
	
	SET vId = LAST_INSERT_ID();
	
	INSERT INTO tReportProperty(cPropertyType, cReport, cValue)
		SELECT c.cId, vId, '' 
			FROM tR_ReportPropertyType_ReportType AS a
			LEFT JOIN tReportProperty AS b ON a.cReportPropertyType = b.cPropertyType AND b.cReport = vId
			LEFT JOIN tReportPropertyType AS c ON a.cReportPropertyType = c.cId 
			WHERE a.cReportType = vType;

#		SELECT cId, vId, '' FROM tReportPropertyType WHERE cReportType=vType;
	
	SELECT vId;
	
END$$

DELIMITER ;