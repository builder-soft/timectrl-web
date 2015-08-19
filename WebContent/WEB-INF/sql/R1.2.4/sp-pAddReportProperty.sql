DROP PROCEDURE if exists pAddReportProperty;
DELIMITER $$

CREATE PROCEDURE pAddReportProperty(IN vKey VARCHAR(30), IN vName VARCHAR(100), IN vReportType BIGINT(20), IN vValue VARCHAR(255))
BEGIN
	DECLARE vId BIGINT(20);
	IF(EXISTS(SELECT cId  FROM tReportPropertyType WHERE cKey=vKey)) THEN
		SELECT cId INTO vId FROM tReportPropertyType WHERE cKey=vKey;
	ELSE
		INSERT INTO tReportPropertyType(cKey, cName) VALUES(vKey, vName);
		SET vId = LAST_INSERT_ID();
	END IF;

#	select vKey, vName, vReportType, vId, vValue;
	
	INSERT INTO tR_ReportPropertyType_ReportType(cReportType, cReportPropertyType) VALUES(vReportType, vId);

	INSERT INTO tReportProperty(cPropertyType, cReport, cValue)	
		SELECT vId, cId, vValue FROM tReport WHERE cType = vReportType;
	
#SELECT vId, cId, vValue FROM tReport WHERE cType = vReportType;		
		
END$$

DELIMITER ;