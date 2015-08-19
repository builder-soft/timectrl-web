drop procedure if exists pListTurnos;
drop procedure if exists pListTurnos2;

drop function if exists fGetLimitTime;
drop function if exists fGetJournalString;
drop procedure if exists pListTurnosAsExcel;
drop function if exists fGetJournalString2;
drop function if exists fGetJournal2;

DROP TABLE IF EXISTS checkinout;
DROP TABLE IF EXISTS userinfo;

ALTER TABLE tDataType CHANGE COLUMN cKey cKey VARCHAR(10) NOT NULL UNIQUE;
ALTER TABLE tReport ADD cKey VARCHAR(20) NOT NULL AFTER cId;
UPDATE tReport SET cKey=cId;
ALTER TABLE tReport CHANGE COLUMN cKey cKey VARCHAR(20) NOT NULL UNIQUE;

ALTER TABLE tReportOutParam CHANGE COLUMN cKey cKey VARCHAR(20) NOT NULL UNIQUE;

ALTER TABLE tReportOutValue DROP FOREIGN KEY ReportOutValue_To_ReportOutType;
RENAME TABLE tReportParam TO tReportInParam;
RENAME TABLE tReportOutType TO tReportType;

ALTER TABLE tReportOutValue DROP COLUMN cType;

ALTER TABLE tReportType CHANGE COLUMN cKey cKey VARCHAR(20) NOT NULL UNIQUE;

ALTER TABLE tReport CHANGE COLUMN cOutType cType BIGINT(20) NOT NULL;

UPDATE tReport SET cKey='LATER' where ckey = '8';

ALTER TABLE tReportParamType CHANGE COLUMN cKey cKey VARCHAR(20) NOT NULL UNIQUE;
ALTER TABLE tReportType CHANGE COLUMN cKey cKey VARCHAR(20) NOT NULL UNIQUE;
ALTER TABLE tReportOutParam CHANGE COLUMN cKey cKey VARCHAR(20) NOT NULL UNIQUE;

ALTER TABLE tReportInParam ADD cLabel VARCHAR(50) NOT NULL AFTER cName;

ALTER TABLE tOption ADD cEnable BIT NOT NULL DEFAULT TRUE;
