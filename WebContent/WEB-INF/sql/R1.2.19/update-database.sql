drop table if exists tcrewLog;
ALTER TABLE tReport ADD cJavaClass varchar(512) NULL AFTER cType;

update tReport set cJavaClass='cl.buildersoft.timectrl.business.services.impl.ReportToAllBossImpl' where ckey='XLS_01_RPT_JEFE_Send';
update tReport set cJavaClass=null where ckey='XLS_01_RPT_JEFE';

#update temployee set cmail='claudio.moscoso@gmail.com' where ifnull(cMail,'') <> '';

create table tProcessedDates



UPDATE tVersion SET cVersion='1.2.19', cUpdated=NOW() WHERE cKey = 'DBT';
