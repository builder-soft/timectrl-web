DROP VIEW IF EXISTS vUser;
CREATE VIEW vUser
AS
		SELECT		a.cId, a.cMail, a.cName 
		FROM 		bsframework.tUser AS a
		LEFT JOIN	bsframework.tR_UserDomain AS b ON a.cId = b.cUser
		LEFT JOIN	bsframework.tDomain AS c ON b.cDomain = c.cId 
		WHERE		!a.cAdmin AND c.cDatabase = DATABASE();

UPDATE tVersion SET cVersion='1.2.14', cUpdated=NOW() WHERE cKey = 'DBT';
