INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('BOTH_MARKS', 'Considera marca de entrada y salida para contabilizar un día en informe', 'true', (select cid from tdatatype where ckey='Boolean'));


UPDATE tVersion SET cVersion='1.2.16', cUpdated=NOW() WHERE cKey = 'DBT';
