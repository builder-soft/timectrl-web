SELECT cId INTO @integerId FROM tDataType WHERE cKey = 'INTEGER';

INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('RANGE_MARK', 'Rango para administracion de marcas', '7', @integerId);

DELETE FROM tParameter WHERE cKey = 'W8COMPATIBLE';

