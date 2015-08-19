DROP PROCEDURE IF EXISTS pListReportPropertyByReportId;
DROP PROCEDURE IF EXISTS pListReportPropertyByReportType;

DELIMITER $$

CREATE PROCEDURE pListReportPropertyByReportId(IN vReportId BIGINT(20))
BEGIN
	DECLARE vType BIGINT(20);
	
	SELECT cType INTO vType FROM tReport WHERE cId = vReportId;
	
	SELECT 
		b.cId 			AS cPropertyId, 
		b.cPropertyType	AS cPropertyType, 
		b.cReport		AS cPropertyReport, 
		b.cValue		AS cPropertyValue,
		c.cId			AS cPropertyTypeId, 
		c.cKey			AS cPropertyTypeKey, 
		c.cName			AS PropertyTypeName
	FROM tR_ReportPropertyType_ReportType AS a
	LEFT JOIN tReportProperty AS b ON a.cReportPropertyType = b.cPropertyType AND b.cReport = vReportId
	LEFT JOIN tReportPropertyType AS c ON a.cReportPropertyType = c.cId 
	WHERE a.cReportType = vType;
	
/*	
	SELECT	* #a.*, b.*, '->', c.*, d.* 
	FROM		tReportProperty AS a
	LEFT JOIN	tReportPropertyType AS b ON a.cPropertyType = b.cId
	LEFT JOIN	tR_ReportPropertyType_ReportType AS c ON a.cPropertyType = c.cReportPropertyType
#	LEFT JOIN	tReport	AS d ON a.cReport = d.cId
	WHERE	a.cReport = vReportId; 
#		AND c.cReportType=d.cType;
*/	
END$$

DELIMITER ;
