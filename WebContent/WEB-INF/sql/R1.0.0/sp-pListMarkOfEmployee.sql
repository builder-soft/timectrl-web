DROP PROCEDURE if exists pListMarkOfEmployee;
DELIMITER $$

CREATE PROCEDURE pListMarkOfEmployee(IN vEmployee BIGINT(20), 
			IN vStartDate DATE, IN vEndDate DATE)
BEGIN
	SELECT	tAttendanceLog.cId					AS 'cId',
			tAttendanceLog.cMachine				AS 'cMachineId', 
			tMachine.cName						AS 'cMachineName', 
			tAttendanceLog.cDate				AS 'cDate',
			fDayOfWeek3(tAttendanceLog.cDate)	AS 'cWeekDay',
			tAttendanceLog.cMarkType			AS 'cMarkTypeId', 
			tMarkType.cName						AS 'cMarkTypeName' 
	FROM 	tAttendanceLog
	LEFT JOIN tEmployee ON tAttendanceLog.cEmployeeKey = tEmployee.cKey
	LEFT JOIN tMachine ON tAttendanceLog.cMachine = tMachine.cId
	LEFT JOIN tMarkType ON tAttendanceLog.cMarkType = tMarkType.cId
	WHERE	tEmployee.cId = vEmployee AND cDate BETWEEN vStartDate AND vEndDate
	ORDER BY cDate;
END$$

DELIMITER ;