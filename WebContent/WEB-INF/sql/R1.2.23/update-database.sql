#cId, cEmployee, cFingerprint, cFlag, cFingerIndex, cCardNumber

create table tFingerprint (
	cId 			BIGINT(20) NOT NULL auto_increment,
	cEmployee		BIGINT(20) NOT NULL,
	cFingerprint	TEXT NULL,
	cFlag			INTEGER NULL,
	cFingerIndex	INTEGER NULL,	
	cCardNumber 	VARCHAR(20),
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

ALTER TABLE tFingerprint
ADD INDEX Fingerprin_index_Employee (cEmployee ASC),
ADD CONSTRAINT Fingerprin_To_Employee FOREIGN KEY (cEmployee) REFERENCES tEmployee(cId);

insert into tFingerprint (cEmployee, cFingerprint, cFlag, cFingerIndex, cCardNumber)
	select cid, cFingerprint, cFlag, cFingerIndex, cCardNumber 
	from temployee 
	where not cFingerprint is null or not cCardNumber is null;

ALTER TABLE tEmployee
  DROP COLUMN cFingerprint,
  DROP COLUMN cFlag,
  DROP COLUMN cFingerIndex,
  DROP COLUMN cCardNumber;	
	
UPDATE tVersion SET cVersion='1.2.23', cUpdated=NOW() WHERE cKey = 'DBT';
