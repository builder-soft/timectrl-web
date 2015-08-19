UPDATE tOption SET cEnable=true WHERE cId=25;
UPDATE tOption SET cEnable=false WHERE cId=26;

CREATE TABLE tR_ReportPropertyType_ReportType (
	cReportType				BIGINT NOT NULL,
	cReportPropertyType		BIGINT NOT NULL,
	PRIMARY KEY(cReportType,cReportPropertyType)
) ENGINE=innoDB;


ALTER TABLE tR_ReportPropertyType_ReportType
ADD INDEX index_ReportType (cReportType ASC),
ADD INDEX index_ReportPropertyType (cReportPropertyType ASC),
ADD CONSTRAINT r_ToReportType FOREIGN KEY (cReportType) REFERENCES tReportType(cId),
ADD CONSTRAINT r_ToReportPropertyType FOREIGN KEY (cReportPropertyType) REFERENCES tReportPropertyType(cId);

INSERT INTO tR_ReportPropertyType_ReportType (cReportType, cReportPropertyType) (
        SELECT d.cid, a.cid 
        FROM tReportPropertyType AS a 
        RIGHT JOIN treportproperty AS b ON b.cPropertyType= a.cid
        RIGHT JOIN treport AS c ON b.creport = c.cid
        RIGHT JOIN treporttype AS d ON c.ctype = d.cid
        WHERE (NOT a.cid IS NULL) AND (NOT c.cid IS NULL)
        GROUP BY d.cid, a.cid
);

delete from tR_ReportPropertyType_ReportType where creporttype=4 and creportpropertytype=5;
