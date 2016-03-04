insert into tEventType(cKey, cName) VALUES('EMPLOYEE_INSERT', 'Nuevo empleado');
insert into tEventType(cKey, cName) VALUES('EMPLOYEE_UPDATE', 'Modificacion datos empleado');
insert into tEventType(cKey, cName) VALUES('EMPLOYEE_DELETE', 'Se desvincula empleado');

UPDATE tVersion SET cVersion='1.2.25', cUpdated=NOW() WHERE cKey = 'DBT';


