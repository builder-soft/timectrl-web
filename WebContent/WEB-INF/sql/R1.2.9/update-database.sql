update treportparamtype set cHTMLFile='Employee.jsp' where cid=1;
 
RENAME TABLE tReportInParam TO tReportParameter;
RENAME TABLE tReportParamType TO tReportParameterType;

ALTER TABLE tReportParameterType MODIFY COLUMN cSource VARCHAR(512);

UPDATE tReportParameterType SET cSource='cl.buildersoft.timectrl.business.services.impl.EmployeeParameterImpl' WHERE cKey = 'EMPLOYEE_LIST';

