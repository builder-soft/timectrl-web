DROP PROCEDURE if exists pListMarkOfEmployee;
DELIMITER $$

CREATE PROCEDURE pListMarkOfEmployee(IN vEmployeeId BIGINT(20), IN vStartDate DATE, 
									IN vEndDate DATE)
BEGIN
	SELECT	tAttendanceLog.cId					AS 'cId',
			tAttendanceLog.cMachine				AS 'cMachineId', 
			tMachine.cName						AS 'cMachineName', 
			tAttendanceLog.cDate				AS 'cDate',
			fDayOfWeek3(tAttendanceLog.cDate)	AS 'cWeekDay',
			tAttendanceLog.cMarkType			AS 'cMarkTypeId', 
			tMarkType.cName						AS 'cMarkTypeName',
			IF(tAttendanceModify.cId IS NULL,'','N')				
												AS 'cType'
	FROM 	tAttendanceLog
	LEFT JOIN tEmployee ON tAttendanceLog.cEmployeeKey = tEmployee.cKey
	LEFT JOIN tMachine ON tAttendanceLog.cMachine = tMachine.cId
	LEFT JOIN tMarkType ON tAttendanceLog.cMarkType = tMarkType.cId
	LEFT JOIN tAttendanceModify ON tAttendanceLog.cId = tAttendanceModify.cAttendanceLog
	WHERE	tEmployee.cId = vEmployeeId AND DATE(cDate) BETWEEN DATE(vStartDate) AND DATE(vEndDate)
	ORDER BY cDate DESC;
END$$

DELIMITER ;