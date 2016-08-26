ALTER TABLE tArea ADD cParent BIGINT(20) NULL AFTER cCostCenter;

ALTER TABLE tArea
ADD INDEX area_index_area (cParent ASC),
ADD CONSTRAINT AreaToArea FOREIGN KEY (cParent) REFERENCES tArea(cId);

UPDATE tVersion SET cVersion='1.2.15', cUpdated=NOW() WHERE cKey = 'DBT';
