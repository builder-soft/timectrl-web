DROP PROCEDURE if exists pDeleteReport;
DELIMITER $$

CREATE PROCEDURE pDeleteReport(IN vId BIGINT(20))
BEGIN
	DELETE FROM tReportProperty WHERE cReport=vId;
	DELETE FROM tReport WHERE cId=vId;
END$$

DELIMITER ;