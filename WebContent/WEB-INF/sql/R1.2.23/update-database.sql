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
	cKey	VARCHAR(20) NOT NULL UNIQUE,
	cName	VARCHAR(100) NOT NULL,
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

create table tEvent (
	cId 		BIGINT(20) NOT NULL auto_increment,
	cEventType	BIGINT(20) NOT NULL,
	cWhen		TIMESTAMP NOT NULL,
	cUser		BIGINT(20) NOT NULL,
	cWhat		TEXT	NOT NULL,
	PRIMARY KEY (cId)
) ENGINE=InnoDB;
  
ALTER TABLE tEvent
ADD INDEX event_index_eventType (cEventType ASC),
ADD CONSTRAINT event_to_eventType FOREIGN KEY (cEventType) REFERENCES tEventType(cId);

insert into tEventType(cKey, cName) VALUES('SECURITY_LOGIN_OK', 'Acceso exitoso');
insert into tEventType(cKey, cName) VALUES('SECURITY_LOGIN_FAIL', 'Acceso fallido');
insert into tEventType(cKey, cName) VALUES('SECURITY_LOGOUT', 'Salida del sistema');
insert into tEventType(cKey, cName) VALUES('CONFIG_FAIL', 'Configuracion fallida en el sistema');
insert into tEventType(cKey, cName) VALUES('NEW_USER', 'Nuevo usuario');
insert into tEventType(cKey, cName) VALUES('DELETE_USER', 'Borrado de usuario');


DELIMITER $$
create procedure pUpdateData_Temp()
begin
	IF NOT EXISTS(	SELECT * 
				FROM bsframework.tUser 
				WHERE cMail = 'SYSTEM') THEN
				
		INSERT INTO bsframework.tUser(cMail, cName, cPassword, cAdmin) VALUES('SYSTEM', 'System Processor', '', 1);
		
	END IF;

	IF NOT EXISTS(	SELECT * 
				FROM bsframework.tUser 
				WHERE cMail = 'ANONYMOUS') THEN
				
		INSERT INTO bsframework.tUser(cMail, cName, cPassword, cAdmin) VALUES('ANONYMOUS', 'Unknown user', '', 0);
		
	END IF;
	
END$$
DELIMITER ;

call pUpdateData_Temp;

drop procedure if exists pUpdateData_Temp;

INSERT INTO tOption(cKey, cLabel, cURL, cParent, cType, cOrder, cEnable, cIsAdmin) VALUES('EVENT_VIEWER', 'Visor de eventos', '/servlet/admin/eventViewer/EventViewerMain', 7, 1, 3, true, false);



UPDATE tVersion SET cVersion='1.2.23', cUpdated=NOW() WHERE cKey = 'DBT';
