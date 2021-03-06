package cl.buildersoft.web.servlet.timectrl.employee;

import java.io.IOException;
import java.sql.Connection;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.business.services.EventLogService;
import cl.buildersoft.framework.business.services.ServiceFactory;
import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.util.BSConnectionFactory;
import cl.buildersoft.framework.util.BSDateTimeUtil;
import cl.buildersoft.framework.web.servlet.BSHttpServlet_;
import cl.buildersoft.timectrl.business.beans.License;
import cl.buildersoft.timectrl.business.services.EmployeeService;
import cl.buildersoft.timectrl.business.services.impl.EmployeeServiceImpl;

/**
 * Servlet implementation class SaveNewLicense
 */
@WebServlet("/servlet/timectrl/employee/SaveNewLicense")
public class SaveNewLicense extends BSHttpServlet_ {
	private static final long serialVersionUID = -7874524353479527912L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		License license = new License();

		String startDate = request.getParameter("StartDate");
		String endDate = request.getParameter("EndDate");
		String cause = request.getParameter("Cause");
		String document = request.getParameter("Document");
		String employeeId = readParameterOrAttribute(request, "cId");

		BSBeanUtils bu = new BSBeanUtils();
		Calendar date = BSDateTimeUtil.string2Calendar(request, startDate);
		date = BSDateTimeUtil.string2Calendar(startDate, getApplicationValue(request, "DateFormat").toString());
		license.setStartDate(BSDateTimeUtil.calendar2Date(date));
		date = BSDateTimeUtil.string2Calendar(request, endDate);
		license.setEndDate(BSDateTimeUtil.calendar2Date(date));

		license.setEmployee(Long.parseLong(employeeId));
		license.setLicenseCause(Long.parseLong(cause));
		license.setDocument(document);

		BSConnectionFactory cf = new BSConnectionFactory();
		Connection conn = cf.getConnection(request);

		// Connection conn = getConnection(request);
		bu.save(conn, license);

		String dateFormat = getApplicationValue(request, "DateFormat").toString();

		EventLogService eventLog = ServiceFactory.createEventLogService();
		eventLog.writeEntry(conn, getCurrentUser(request).getId(), "NEW_LICENSE",
				"Agregó licencia o permiso al empleado '%s' de manera online. Para el día %s al %s.",
				idToRut(conn, license.getEmployee()), BSDateTimeUtil.date2String(license.getStartDate(), dateFormat),
				BSDateTimeUtil.date2String(license.getEndDate(), dateFormat));
		cf.closeConnection(conn);

		request.setAttribute("cId", employeeId);
		forward(request, response, "/servlet/timectrl/employee/LicenseOfEmployee");

	}

	private Object idToRut(Connection conn, Long employee) {
		EmployeeService es = new EmployeeServiceImpl();
		return es.getEmployee(conn, employee).getRut();
	}
}
