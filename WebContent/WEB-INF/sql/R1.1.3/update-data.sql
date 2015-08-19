SELECT cId INTO @dataTypeId FROM tDataType WHERE cKey = 'STRING';
SELECT cId INTO @dataTypeNumId FROM tDataType WHERE cKey = 'INTEGER';


INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('INFER_TIME1', 'Horario 1 de finferencia de turno rotativo', '00:00:00', @dataTypeId);
INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('INFER_TIME2', 'Horario 2 de finferencia de turno rotativo', '08:00:00', @dataTypeId);
INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('INFER_TIME3', 'Horario 3 de finferencia de turno rotativo', '16:00:00', @dataTypeId);
INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('INFER_TIME4', 'Horario 4 de finferencia de turno rotativo', '20:00:00', @dataTypeId);

INSERT INTO tParameter(cKey, cLabel, cValue, cDataType) VALUES('TOLERANCE_INFERENCE', 'Tolerancia Horario diferido (minutos)', '180', @dataTypeNumId);

