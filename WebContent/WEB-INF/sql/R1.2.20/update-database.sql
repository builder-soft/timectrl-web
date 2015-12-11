ALTER TABLE tMachine MODIFY COLUMN cIP VARCHAR(50);

UPDATE tVersion SET cVersion='1.2.20', cUpdated=NOW() WHERE cKey = 'DBT';
