SELECT cId INTO @dataTypeId FROM tDataType WHERE cKey = 'BOOLEAN';

INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('AREA_FILTER', 'Indica si se filtran los empleados por area', 'false', @dataTypeId);
