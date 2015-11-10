package cl.buildersoft.web.servlet.timectrl.employee;

import java.io.IOException;
import java.sql.Connection;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.util.BSDateTimeUtil;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.business.beans.License;

/**
 * Servlet implementation class SaveNewLicense
 */
@WebServlet("/servlet/timectrl/employee/SaveNewLicense")
public class SaveNewLicense extends BSHttpServlet {
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
		license.setStartDate(BSDateTimeUtil.calendar2Date(date));
		date = BSDateTimeUtil.string2Calendar(request, endDate);
		license.setEndDate(BSDateTimeUtil.calendar2Date(date));

		license.setEmployee(Long.parseLong(employeeId));
		license.setLicenseCause(Long.parseLong(cause));
		license.setDocument(document);

		Connection conn = getConnection(request);
		bu.save(conn, license);

		request.setAttribute("cId", employeeId);
		forward(request, response, "/servlet/timectrl/employee/LicenseOfEmployee");

	}
}
