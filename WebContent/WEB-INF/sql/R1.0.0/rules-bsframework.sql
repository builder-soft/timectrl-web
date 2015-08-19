ALTER TABLE bsframework.tR_UserDomain
ADD PRIMARY KEY(cUser, cDomain),
ADD INDEX index_domain (cDomain ASC),
ADD INDEX index_user (cUser ASC),
ADD CONSTRAINT r_UserDomainToUser FOREIGN KEY (cUser) REFERENCES bsframework.tUser(cId),
ADD CONSTRAINT r_UserDomainToDomain FOREIGN KEY (cDomain) REFERENCES bsframework.tDomain(cId);

ALTER TABLE bsframework.tDomainAttribute
ADD INDEX domainAttribute_index_domain (cDomain ASC),
ADD CONSTRAINT domainAttributeToDomain FOREIGN KEY (cDomain) REFERENCES bsframework.tDomain(cId);

/*
ALTER TABLE bsframework.tR_UserDomain ADD PRIMARY KEY(cUser, cDomain);
*/


