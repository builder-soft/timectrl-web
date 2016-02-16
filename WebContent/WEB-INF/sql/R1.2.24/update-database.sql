insert into tEventType(cKey, cName) VALUES('BUILD_REPORT', 'Ejecución de reporte');
insert into tEventType(cKey, cName) VALUES('UPDATE_USER', 'Actualizacion de usuario');

drop table tFileContent;
drop table tFile;
drop table ttimectrl;


UPDATE tVersion SET cVersion='1.2.24', cUpdated=NOW() WHERE cKey = 'DBT';
