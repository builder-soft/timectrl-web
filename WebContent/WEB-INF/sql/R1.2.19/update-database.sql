alter table tCrewProcess MODIFY COLUMN cEmployee BIGINT(20) NULL;

UPDATE tVersion SET cVersion='1.2.19', cUpdated=NOW() WHERE cKey = 'DBT';
