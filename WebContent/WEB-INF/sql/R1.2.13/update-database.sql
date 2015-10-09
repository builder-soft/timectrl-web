CREATE TABLE IF NOT EXISTS tCrewLog(
	cId				BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	cAttendanceLog	BIGINT NOT NULL
) ENGINE=innoDB;

ALTER TABLE tCrewLog
ADD INDEX CrewLog_index_AttendanceLog (cAttendanceLog ASC),
ADD CONSTRAINT CrewLog_To_AttendanceLog FOREIGN KEY (cAttendanceLog) REFERENCES tAttendanceLog(cId);

CREATE TABLE IF NOT EXISTS tCrewProcess(
	cId				BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	cDate			DATE NOT NULL,
	cEmployee		BIGINT NOT NULL,
	cHoursWorked	INTEGER DEFAULT '0' COMMENT 'Indica cuantas horas trabajo',
	cWorked			BIT	DEFAULT 0 COMMENT 'Indica que la persona fue o no a trabajar',
	cHired			BIT DEFAULT 0 COMMENT 'Indica que la persona tiene turno de trabajo ese día.'
) ENGINE=innoDB;

ALTER TABLE tCrewProcess
ADD INDEX CrewProcess_index_Employee (cEmployee ASC),
ADD CONSTRAINT CrewProcess_To_Employee FOREIGN KEY (cEmployee) REFERENCES tEmployee(cId);

/*DATOS PARA HACER PRUEBAS*/
delete from tCrewProcess;
INSERT INTO tCrewProcess (cDate, cEmployee, cHoursWorked, cWorked, cHired) VALUES ('2015-05-01', 1, 3.1, TRUE, TRUE);
INSERT INTO tCrewProcess (cDate, cEmployee, cHoursWorked, cWorked, cHired) VALUES ('2015-05-02', 1, 4.4, TRUE, TRUE);
INSERT INTO tCrewProcess (cDate, cEmployee, cHoursWorked, cWorked, cHired) VALUES ('2015-05-03', 1, 7.3, TRUE, TRUE);
INSERT INTO tCrewProcess (cDate, cEmployee, cHoursWorked, cWorked, cHired) VALUES ('2015-05-04', 1, 8.2, TRUE, TRUE);
INSERT INTO tCrewProcess (cDate, cEmployee, cHoursWorked, cWorked, cHired) VALUES ('2015-05-01', 2, 3.1, TRUE, TRUE);
INSERT INTO tCrewProcess (cDate, cEmployee, cHoursWorked, cWorked, cHired) VALUES ('2015-05-02', 2, 4.4, TRUE, FALSE);
INSERT INTO tCrewProcess (cDate, cEmployee, cHoursWorked, cWorked, cHired) VALUES ('2015-05-03', 2, 7.3, TRUE, TRUE);
INSERT INTO tCrewProcess (cDate, cEmployee, cHoursWorked, cWorked, cHired) VALUES ('2015-05-04', 2, 8.2, TRUE, TRUE);
INSERT INTO tCrewProcess (cDate, cEmployee, cHoursWorked, cWorked, cHired) VALUES ('2015-05-01', 3, 3.1, TRUE, TRUE);
INSERT INTO tCrewProcess (cDate, cEmployee, cHoursWorked, cWorked, cHired) VALUES ('2015-05-02', 3, 4.4, TRUE, TRUE);
INSERT INTO tCrewProcess (cDate, cEmployee, cHoursWorked, cWorked, cHired) VALUES ('2015-05-03', 3, 7.3, TRUE, FALSE);
INSERT INTO tCrewProcess (cDate, cEmployee, cHoursWorked, cWorked, cHired) VALUES ('2015-05-04', 3, 8.2, TRUE, TRUE);
INSERT INTO tCrewProcess (cDate, cEmployee, cHoursWorked, cWorked, cHired) VALUES ('2015-05-01', 4, 3.1, TRUE, TRUE);
INSERT INTO tCrewProcess (cDate, cEmployee, cHoursWorked, cWorked, cHired) VALUES ('2015-05-02', 4, 4.4, TRUE, TRUE);
INSERT INTO tCrewProcess (cDate, cEmployee, cHoursWorked, cWorked, cHired) VALUES ('2015-05-03', 4, 7.3, TRUE, TRUE);
INSERT INTO tCrewProcess (cDate, cEmployee, cHoursWorked, cWorked, cHired) VALUES ('2015-05-04', 4, 8.2, TRUE, TRUE);

select cdate as 'fecha', count(cemployee) as 'Emploeados', sum(cHoursWorked) as 'horas trabajadas', sum(cworked) as 'presente', sum(cHired) as 'contratadas'
from tCrewProcess 
where cemployee in (2,3)
group by cdate;
/* FIN DATOS PARA HACER PRUEBAS*/



UPDATE tVersion SET cVersion='1.2.13', cUpdated=NOW() WHERE cKey = 'DBT';

