ALTER TABLE tReport ADD cJavaClass varchar(512) NULL AFTER cType;

update tReport set cJavaClass='cl.buildersoft.timectrl.business.services.impl.ReportToAllBossImpl' where ckey='XLS_01_RPT_JEFE_Send';
update tReport set cJavaClass=null where ckey='XLS_01_RPT_JEFE';


UPDATE tVersion SET cVersion='R1.2.19-B', cUpdated=NOW() WHERE cKey = 'DBT';
