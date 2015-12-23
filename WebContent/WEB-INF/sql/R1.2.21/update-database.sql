ALTER TABLE tMachine MODIFY COLUMN cIP VARCHAR(50);
ALTER TABLE tR_EmployeeTurn ADD cException BIT NULL AFTER cEndDate;
UPDATE tR_EmployeeTurn SET cException = FALSE;
ALTER TABLE tR_EmployeeTurn MODIFY COLUMN cException BIT NOT NULL DEFAULT FALSE;


/*
RENAME TABLE tEmployee TO tEmployeeData;

CREATE OR REPLACE VIEW tEmployee AS 
	SELECT	cId, cKey, cRut, cName, cPost, cArea, cPrivilege, cEnabled, cGroup, cUsername, cMail, cBoss, 
			cFingerprint, cFlag, cFingerIndex, cCardNumber 
	FROM tEmployeeData
	WHERE cEnabled=TRUE;
	
CREATE OR REPLACE VIEW tFingerPrint AS 
	SELECT cId, cId AS cEmployee, cFingerprint, cFlag, cFingerIndex, cCardNumber 
	FROM tEmployeeData
	WHERE cEnabled=TRUE;
*/

/**
cId, cKey, cRut, cName, cPost, cArea, cPrivilege, cEnabled, cGroup, cUsername, cMail, cBoss

cId, cEmployee, cFingerprint, cFlag, cFingerIndex, cCardNumber
 */
	
	
#backup-rsa-20151221.txt

UPDATE tVersion SET cVersion='1.2.20', cUpdated=NOW() WHERE cKey = 'DBT';
