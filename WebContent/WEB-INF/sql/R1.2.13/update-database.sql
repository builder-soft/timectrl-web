CREATE TABLE IF NOT EXISTS tCrewLog(
	cId				BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	cAttendanceLog	BIGINT NOT NULL
) ENGINE=innoDB;

ALTER TABLE tCrewLog
ADD INDEX CrewLog_index_AttendanceLog (cAttendanceLog ASC),
ADD CONSTRAINT CrewLog_To_AttendanceLog FOREIGN KEY (cAttendanceLog) REFERENCES tAttendanceLog(cId);

UPDATE tVersion SET cVersion='1.2.13', cUpdated=NOW() WHERE cKey = 'DBT';

