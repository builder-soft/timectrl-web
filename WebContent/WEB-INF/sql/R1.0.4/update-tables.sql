#desc tReportParam;

ALTER TABLE tReportParam ADD cFromUser BIT;
ALTER TABLE tReportParam ADD cOrder INTEGER;

UPDATE tReportParam SET cFromUser = TRUE;

ALTER TABLE tReportParam CHANGE COLUMN cFromUser cFromUser BIT NOT NULL DEFAULT TRUE;

