DROP PROCEDURE IF EXISTS pExistsLicense;

DELIMITER $$

/** Inicio */
CREATE PROCEDURE pExistsLicense(IN vEmployeeId BIGINT(20), IN vLicenseCause BIGINT(20), IN vDocument VARCHAR(15), IN vStartDate DATE, IN vEndDate DATE)
#cEmployee=? AND cLicenseCause=? AND cDocument=? AND cStartDate=? AND cEndDate
BEGIN

	SELECT COUNT(cId) AS counter 
	FROM tLicense 
	WHERE cEmployee=vEmployeeId AND cLicenseCause=vLicenseCause AND cDocument=vDocument AND cStartDate=vStartDate AND cEndDate=vEndDate;
	
END$$


DELIMITER ;
