DROP PROCEDURE if exists pListReportInputParameter;
DROP PROCEDURE if exists pListReportParameter;
DELIMITER $$

CREATE PROCEDURE pListReportParameter(IN vReport BIGINT(20))
BEGIN
	SELECT 
		A.cId			AS cId,
		A.cReport		AS cReport,
		A.cName			AS cName,
		A.cLabel		AS cLabel,
		A.cOrder		AS cOrder,
		B.cId			AS cTypeId,
		B.cKey			AS cTypeKey,
		B.cName			AS cTypeName,
		B.cHTMLFile		AS cTypeHTMLFile, 
		B.cSource		AS cTypeSource,
		B.cJavaType		AS cJavaType
		
	FROM tReportParameter AS A 
	LEFT JOIN tReportParameterType AS B ON A.cType = B.cId
	WHERE cReport = vReport
	ORDER BY cOrder;

END$$

DELIMITER ;