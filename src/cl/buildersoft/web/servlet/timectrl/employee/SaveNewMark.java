package cl.buildersoft.web.servlet.timectrl.employee;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Timestamp;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.util.BSDateTimeUtil;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.business.beans.AttendanceLog;
import cl.buildersoft.timectrl.business.beans.AttendanceModify;
import cl.buildersoft.timectrl.business.beans.Employee;
import cl.buildersoft.timectrl.business.services.EmployeeService;
import cl.buildersoft.timectrl.business.services.MachineService2;
import cl.buildersoft.timectrl.business.services.impl.EmployeeServiceImpl;
import cl.buildersoft.timectrl.business.services.impl.MachineServiceImpl2;

@WebServlet("/servlet/config/employee/SaveNewMark")
public class SaveNewMark extends BSHttpServlet {
	private static final long serialVersionUID = 7636128427858862866L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long employeeId = Long.parseLong(request.getParameter("Employee"));
		Long machine = Long.parseLong(request.getParameter("Machine"));
		String dateTimeString = request.getParameter("DateTimeMark");
		Long markType = Long.parseLong(request.getParameter("MarkType"));
		String today = request.getParameter("Today");
		Connection conn = getConnection(request);

		String dateTimeFormat = BSDateTimeUtil.getFormatDatetime(conn);
		Calendar dateTime = BSDateTimeUtil.string2Calendar(dateTimeString, dateTimeFormat);

		BSBeanUtils bu = new BSBeanUtils();
		AttendanceModify attendanceModify = new AttendanceModify();
		AttendanceLog attendanceLog = new AttendanceLog();

		fillAttendanceLog(employeeId, machine, markType, conn, dateTime, attendanceLog);
		saveAttendance(conn, attendanceLog);
		fillAttendanceModify(request, employeeId, machine, markType, dateTime, attendanceModify, attendanceLog.getId());

		bu.save(conn, attendanceModify);

		request.setAttribute("cId", "" + employeeId);
		request.setAttribute("Today", today);

		forward(request, response, "/servlet/timectrl/employee/MarkAdmin");
	}

	private void saveAttendance(Connection conn, AttendanceLog attendanceLog) {
		MachineService2 machine = new MachineServiceImpl2();
		machine.saveAttendanceLog(conn, attendanceLog);
	}

	private void fillAttendanceLog(Long employeeId, Long machine, Long markType, Connection conn, Calendar dateTime,
			AttendanceLog attendanceLog) {
		// attendanceLog.setDate(BSDateTimeUtil.calendar2Timestamp(dateTime));
		attendanceLog.setYear(dateTime.get(Calendar.YEAR));
		attendanceLog.setMonth(dateTime.get(Calendar.MONTH) + 1);
		attendanceLog.setDay(dateTime.get(Calendar.DATE));
		attendanceLog.setHour(dateTime.get(Calendar.HOUR));
		attendanceLog.setMinute(dateTime.get(Calendar.MINUTE));
		attendanceLog.setSecond(dateTime.get(Calendar.SECOND));

		attendanceLog.setEmployeeKey(searchEmployeeById(conn, employeeId).getKey());
		attendanceLog.setMachine(machine);
		attendanceLog.setMarkType(markType);
	}

	private Employee searchEmployeeById(Connection conn, Long employeeId) {
		EmployeeService service = new EmployeeServiceImpl();
		return service.getEmployee(conn, employeeId);
	}

	private void fillAttendanceModify(HttpServletRequest request, Long employee, Long machine, Long markType, Calendar dateTime,
			AttendanceModify attendanceModify, Long id) {
		attendanceModify.setEmployee(employee);
		attendanceModify.setNewDate(BSDateTimeUtil.calendar2Timestamp(dateTime));
		attendanceModify.setNewMachine(machine);
		attendanceModify.setNewMarkType(markType);
		attendanceModify.setWhen(new Timestamp(System.currentTimeMillis()));
		attendanceModify.setWho(getCurrentUser(request).getId());
		attendanceModify.setAttendanceLog(id);
	}
}
