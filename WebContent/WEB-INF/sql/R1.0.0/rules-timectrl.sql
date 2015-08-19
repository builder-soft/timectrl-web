/** L L A V E S   F O R A N E A S **/

/** EMPLOYEE 
ALTER TABLE tEmployee
ADD INDEX Employee_index_MaritalStatus (cMaritalStatus ASC),
ADD INDEX Employee_index_Country (cCountry ASC),
ADD INDEX Employee_index_Genere (cGenere ASC),
ADD INDEX comuna_index (cComuna ASC),
ADD CONSTRAINT withMaritalStatus FOREIGN KEY (cMaritalStatus) REFERENCES tMaritalStatus(cId),
ADD CONSTRAINT withCountry       FOREIGN KEY (cCountry) REFERENCES tCountry(cId),
ADD CONSTRAINT EmployeeToGenere FOREIGN KEY (cGenere) REFERENCES tGenere(cId),
ADD CONSTRAINT employeeToComuna FOREIGN KEY (cComuna) REFERENCES tComuna(cId);
*/
ALTER TABLE tEmployee
ADD INDEX Employee_index_Post (cPost ASC),
ADD INDEX Employee_index_Area (cArea ASC),
ADD INDEX Employee_index_Privilege (cPrivilege ASC),
ADD CONSTRAINT EmployeeToPost FOREIGN KEY (cPost) REFERENCES tPost(cId),
ADD CONSTRAINT EmployeeToArea FOREIGN KEY (cArea) REFERENCES tArea(cId),
ADD CONSTRAINT EmployeeToPrivilege FOREIGN KEY (cPrivilege) REFERENCES tPrivilege(cId);

ALTER TABLE tR_EmployeeTurn
ADD INDEX R_EmployeeTurn_index_Employee (cEmployee ASC),
ADD INDEX R_EmployeeTurn_index_Turn (cTurn ASC),
ADD CONSTRAINT R_EmployeeTurn_To_Employee FOREIGN KEY (cEmployee) REFERENCES tEmployee(cId),
ADD CONSTRAINT R_EmployeeTurn_To_Turn FOREIGN KEY (cTurn) REFERENCES tTurn(cId);

ALTER TABLE tTurnDay
ADD INDEX TurnDay_index_Turn (cTurn ASC),
ADD CONSTRAINT TurnDay_To_Turn FOREIGN KEY (cTurn) REFERENCES tTurn(cId);

ALTER TABLE tLicense
ADD INDEX License_index_LicenseCause (cLicenseCause ASC),
ADD INDEX License_index_Employee (cEmployee ASC),
ADD CONSTRAINT LicenseToLicenseCause FOREIGN KEY (cLicenseCause) REFERENCES tLicenseCause(cId),
ADD CONSTRAINT LicenseToEmployee FOREIGN KEY (cEmployee) REFERENCES tEmployee(cId);

/************* F R A M E W O R K **********/
/** PARAMETER */
ALTER TABLE tParameter
ADD INDEX Parameter_index (cDataType ASC),
ADD CONSTRAINT ParameterToDataType FOREIGN KEY (cDataType) REFERENCES tDataType(cId);

/** ROL-OPTION */
ALTER TABLE tR_RolOption
ADD INDEX index_rol (cRol ASC),
ADD INDEX index_option (cOption ASC),
ADD CONSTRAINT RolOption_To_Rol FOREIGN KEY (cRol) REFERENCES tRol(cId),
ADD CONSTRAINT RolOption_To_Option FOREIGN KEY (cOption) REFERENCES tOption(cId);

/** USER-ROL */
ALTER TABLE tR_UserRol
ADD INDEX index_rol (cRol ASC),
ADD INDEX index_user (cUser ASC),
ADD CONSTRAINT r_UserRolToRol FOREIGN KEY (cRol) REFERENCES tRol(cId);/*,
ADD CONSTRAINT r_RolOptionToOption FOREIGN KEY (cOption) REFERENCES tOption(cId);*/

/* FILE */
ALTER TABLE tFileContent
ADD INDEX FileContent_index_File (cFile ASC),
ADD CONSTRAINT FileContentToFile FOREIGN KEY (cFile) REFERENCES tFile(cId);

/* cEmployeeKey, cDate, cMarkType */

ALTER TABLE tAttendanceLog
ADD INDEX AttendanceLog_index_Machine (cMachine ASC),
ADD INDEX AttendanceLog_index_MarkType (cMachine ASC),

ADD INDEX AttendanceLog_index_FastSearch (cEmployeeKey, cDate, cMarkType),

ADD CONSTRAINT AttendanceLog_To_Machine FOREIGN KEY (cMachine) REFERENCES tMachine(cId),
ADD CONSTRAINT AttendanceLog_To_MarkType FOREIGN KEY (cMarkType) REFERENCES tMarkType(cId);

/**  R E P O R T E S  */
ALTER TABLE tReportParam
ADD INDEX ReportParam_index_Report (cReport ASC),
ADD INDEX ReportParam_index_Type (cType ASC),
ADD CONSTRAINT ReportParam_To_Report FOREIGN KEY (cReport) REFERENCES tReport(cId),
ADD CONSTRAINT ReportParam_To_ReportParamType FOREIGN KEY (cType) REFERENCES tReportParamType(cId);

ALTER TABLE tReportOutParam
ADD INDEX ReportOutParam_index_ReportOutType (cType ASC),
ADD CONSTRAINT ReportOutParam_To_ReportOutType FOREIGN KEY (cType) REFERENCES tReportOutType(cId);

ALTER TABLE tReport
ADD INDEX Report_index_ReportOutType (cOutType ASC),
ADD CONSTRAINT Report_To_ReportOutType FOREIGN KEY (cOutType) REFERENCES tReportOutType(cId);

ALTER TABLE tReportOutValue
ADD INDEX ReportOutValue_index_ReportOutParam (cParam ASC),
ADD INDEX ReportOutValue_index_ReportOutType (cType ASC),
ADD INDEX ReportOutValue_index_ReportOutReport (cReport ASC),
ADD CONSTRAINT ReportOutValue_To_ReportOutParam FOREIGN KEY (cParam) REFERENCES tReportOutParam(cId),
ADD CONSTRAINT ReportOutValue_To_ReportOutType FOREIGN KEY (cType) REFERENCES tReportOutType(cId),
ADD CONSTRAINT ReportOutValue_To_ReportOutReport FOREIGN KEY (cReport) REFERENCES tReport(cId);
