package cl.buildersoft.web.servlet.timectrl.employee;

import java.io.IOException;
import java.sql.Connection;
import java.util.Calendar;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.business.services.EventLogService;
import cl.buildersoft.framework.business.services.ServiceFactory;
import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.util.BSDateTimeUtil;
import cl.buildersoft.framework.web.servlet.BSHttpServlet_;
import cl.buildersoft.timectrl.business.beans.Employee;
import cl.buildersoft.timectrl.business.beans.EmployeeTurn;
import cl.buildersoft.timectrl.business.beans.Turn;
import cl.buildersoft.timectrl.business.services.EmployeeTurnService;
import cl.buildersoft.timectrl.business.services.impl.EmployeeTurnServiceImpl;

/**
 * Servlet implementation class SaveNewTurn
 */
@WebServlet("/servlet/timectrl/employee/SaveNewTurn")
public class SaveNewTurn extends BSHttpServlet_ {
	private static final Logger LOG = Logger.getLogger(SaveNewTurn.class.getName());

	private static final long serialVersionUID = 3010813754466559516L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long employeeId = Long.parseLong(request.getParameter("Employee"));
		Employee employee = new Employee();
		Long turn = Long.parseLong(request.getParameter("Turn"));
		Turn turnObject = new Turn();
		String start = request.getParameter("StartDate");
		String end = request.getParameter("EndDate");

		String turnId = request.getParameter("TurnId");
		Boolean exception = Boolean.parseBoolean(request.getParameter("Exception"));

		LOG.log(Level.FINE, "Exception : {0}", exception);

		Connection conn = getConnection(request);
		BSBeanUtils bu = new BSBeanUtils();

		employee.setId(employeeId);
		bu.search(conn, employee);

		turnObject.setId(turn);
		bu.search(conn, turnObject);

		String formatDate = BSDateTimeUtil.getFormatDate(conn);

		Calendar startDate = BSDateTimeUtil.string2Calendar(start, formatDate);
		Calendar endDate = BSDateTimeUtil.string2Calendar(end, formatDate);

		EmployeeTurn employeeTurn = new EmployeeTurn();
		employeeTurn.setTurn(turn);
		employeeTurn.setStartDate(startDate);
		employeeTurn.setEndDate(endDate);
		employeeTurn.setException(exception);
		EmployeeTurnService service = new EmployeeTurnServiceImpl();

		EventLogService els = ServiceFactory.createEventLogService();
		String msg = "el turno %s del empleado %s (%s) con rango %s a %s del turno '%s'";
		if (turnId.length() > 0) {
			Long turnIdAsLong = Long.parseLong(turnId);
			employeeTurn.setId(turnIdAsLong);

			service.update(conn, employeeTurn);
			els.writeEntry(conn, getCurrentUser(request).getId(), "UPDATE_TURN", "Actualiza " + msg, exception ? "excepcional"
					: "", employee.getName(), employee.getRut(), BSDateTimeUtil.calendar2String(startDate, formatDate),
					BSDateTimeUtil.calendar2String(endDate, formatDate), turnObject.getName());

		} else {
			employeeTurn.setEmployee(employeeId);

			service.appendNew(conn, employeeTurn);

			els.writeEntry(conn, getCurrentUser(request).getId(), "INSERT_TURN", "Agrega " + msg, exception ? "excepcional" : "",
					employee.getName(), employee.getRut(), BSDateTimeUtil.calendar2String(startDate, formatDate),
					BSDateTimeUtil.calendar2String(endDate, formatDate), turnObject.getName());
		}
		closeConnection(conn);

		request.setAttribute("cId", employeeId.toString());
		request.setAttribute("Exception", exception);

		forward(request, response, "/servlet/timectrl/employee/TurnsOfEmployee");

	}

}
