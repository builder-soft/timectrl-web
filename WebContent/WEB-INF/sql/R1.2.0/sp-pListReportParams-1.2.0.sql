DROP PROCEDURE if exists pListReportParams;
DELIMITER $$

CREATE PROCEDURE pListReportParams(IN vIdReport BIGINT(20))
BEGIN	
	SELECT	cId
	FROM	tReportInParam
	WHERE	cReport = vIdReport
	ORDER BY cOrder;

END$$

DELIMITER ;