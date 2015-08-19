INSERT INTO bsframework.tDomain(cName, cAlias) VALUES('timectrl', 'timectrl');

SET @domainId = LAST_INSERT_ID();

INSERT INTO bsframework.tUser(cMail, cName, cPassword, cAdmin) VALUES('admin', 'Administrador', md5('admin'), 1);
SET @userId = LAST_INSERT_ID();
INSERT INTO bsframework.tR_UserDomain(cUser, cDomain) VALUES(1, 1);
INSERT INTO bsframework.tDomainAttribute(cDomain, cKey, cName, cValue) VALUES(1, 'database.driver', 'Driver', 'org.gjt.mm.mysql.Driver');
INSERT INTO bsframework.tDomainAttribute(cDomain, cKey, cName, cValue) VALUES(1, 'database.server', 'Server', 'localhost');
INSERT INTO bsframework.tDomainAttribute(cDomain, cKey, cName, cValue) VALUES(1, 'database.database', 'Database', 'timectrl');
INSERT INTO bsframework.tDomainAttribute(cDomain, cKey, cName, cValue) VALUES(1, 'database.username', 'User', 'root');
INSERT INTO bsframework.tDomainAttribute(cDomain, cKey, cName, cValue) VALUES(1, 'database.password', 'Password', 'admin');

