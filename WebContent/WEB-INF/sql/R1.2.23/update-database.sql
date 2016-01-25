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
	

create table tEventType (
	cId 	BIGINT(20) NOT NULL auto_increment,
	cKey	VARCHAR(20) NOT NULL,
	cName	VARCHAR(100) NOT NULL,
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

create table tEvent (
	cId 		BIGINT(20) NOT NULL auto_increment,
	cEventType	BIGINT(20) NOT NULL,
	cWhen		TIMESTAMP NOT NULL,
	cWho		BIGINT(20) NOT NULL,
	cWhat		TEXT	NOT NULL,
	PRIMARY KEY (cId)
) ENGINE=InnoDB;
  
ALTER TABLE tEvent
ADD INDEX event_index_eventType (cEventType ASC),
ADD CONSTRAINT event_to_eventType FOREIGN KEY (cEventType) REFERENCES tEventType(cId);

insert into tEventType()

UPDATE tVersion SET cVersion='1.2.23', cUpdated=NOW() WHERE cKey = 'DBT';
