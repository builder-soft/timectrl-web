insert into tEventType(cKey, cName) VALUES('EMPLOYEE_INSERT', 'Nuevo empleado');
insert into tEventType(cKey, cName) VALUES('EMPLOYEE_UPDATE', 'Modificacion datos empleado');
insert into tEventType(cKey, cName) VALUES('EMPLOYEE_DELETE', 'Se desvincula empleado');
insert into tEventType(cKey, cName) VALUES('CHANGE_DOMAIN', 'Cambio a otro dominio');
insert into tEventType(cKey, cName) VALUES('NEW_LICENSE', 'Nueva licencia o permiso');
insert into tEventType(cKey, cName) VALUES('NEW_MARK', 'Nueva marca');
insert into tEventType(cKey, cName) VALUES('INCORPORATE_EMPL', 'Incorporación de empleado.');



UPDATE tVersion SET cVersion='1.2.25', cUpdated=NOW() WHERE cKey = 'DBT';


