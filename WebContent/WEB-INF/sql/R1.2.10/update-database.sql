update toption set cOrder = 9 where ckey='REP_CONFIG';
#update treportparametertype set cJavaType='STRING' where cid=1;

update treportparametertype set cJavaType='LONG' where cid=1;

ALTER TABLE tOption ADD COLUMN cIsAdmin BIT NOT NULL DEFAULT FALSE AFTER cEnable;

update toption set cIsAdmin = true where cKey = 'DOMAIN_MGR';
update toption set cIsAdmin = true where cKey = 'DOMAIN_ATTR_MGR';

DROP VIEW IF EXISTS bsframework.vUser;
CREATE VIEW bsframework.vUser
AS
		SELECT		a.cId, a.cMail, a.cName 
		FROM 		bsframework.tUser AS a
	#	LEFT JOIN	tR_UserDomain AS b ON a.cId = b.cUser
		WHERE		!a.cAdmin;
 
		