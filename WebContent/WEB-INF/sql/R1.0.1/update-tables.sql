DROP TABLE IF EXISTS tAttendanceModify;
create table tAttendanceModify(
	cId				BIGINT(20) NOT NULL auto_increment,
	cWho			BIGINT(20) NOT NULL,
	cWhen			TIMESTAMP NOT NULL,
	cEmployee		BIGINT(20) NOT NULL,
	cAttendanceLog	BIGINT(20) NULL COMMENT 'Apply only when is modify, else is null',
	cOldMachine		BIGINT(20) NULL,
	cNewMachine		BIGINT(20) NOT NULL,
	cOldDate		TIMESTAMP NULL,
	cNewDate		TIMESTAMP NOT NULL,
	cOldMarkType	BIGINT(20) NULL,
	cNewMarkType	BIGINT(20) NOT NULL,
	PRIMARY KEY (cId)
) ENGINE=InnoDB;

