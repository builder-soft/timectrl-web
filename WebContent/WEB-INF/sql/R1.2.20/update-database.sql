ALTER TABLE tMachine MODIFY COLUMN cIP VARCHAR(50);
ALTER TABLE tR_EmployeeTurn ADD cException BIT NULL AFTER cEndDate;
UPDATE tR_EmployeeTurn SET cException = FALSE;
ALTER TABLE tR_EmployeeTurn MODIFY COLUMN cException BIT NOT NULL DEFAULT FALSE;


UPDATE tVersion SET cVersion='1.2.20', cUpdated=NOW() WHERE cKey = 'DBT';
