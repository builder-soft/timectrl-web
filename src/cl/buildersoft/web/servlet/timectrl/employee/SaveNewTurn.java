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

import cl.buildersoft.framework.util.BSDateTimeUtil;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.business.beans.EmployeeTurn;
import cl.buildersoft.timectrl.business.services.EmployeeTurnService;
import cl.buildersoft.timectrl.business.services.impl.EmployeeTurnServiceImpl;
import cl.buildersoft.web.servlet.login.ValidateLoginServlet;

/**
 * Servlet implementation class SaveNewTurn
 */
@WebServlet("/servlet/timectrl/employee/SaveNewTurn")
public class SaveNewTurn extends BSHttpServlet {
	private static final Logger LOG = Logger.getLogger(SaveNewTurn.class.getName());
	
	private static final long serialVersionUID = 3010813754466559516L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long employee = Long.parseLong(request.getParameter("Employee"));
		Long turn = Long.parseLong(request.getParameter("Turn"));
		String start = request.getParameter("StartDate");
		String end = request.getParameter("EndDate");

		String turnId = request.getParameter("TurnId");
		Boolean exception = Boolean.parseBoolean(request.getParameter("Exception"));
		
		LOG.log(Level.FINE, "Exception : {0}", exception);

		Connection conn = getConnection(request);
		String formatDate = BSDateTimeUtil.getFormatDate(conn);

		Calendar startDate = BSDateTimeUtil.string2Calendar(start, formatDate);
		Calendar endDate = BSDateTimeUtil.string2Calendar(end, formatDate);

		EmployeeTurn employeeTurn = new EmployeeTurn();
		employeeTurn.setTurn(turn);
		employeeTurn.setStartDate(startDate);
		employeeTurn.setEndDate(endDate);
		employeeTurn.setException(exception);
		EmployeeTurnService service = new EmployeeTurnServiceImpl();

		if (turnId.length() > 0) {
			Long turnIdAsLong = Long.parseLong(turnId);
			employeeTurn.setId(turnIdAsLong);

			service.update(conn, employeeTurn);
		} else {
			employeeTurn.setEmployee(employee);

			service.appendNew(conn, employeeTurn);
		}
		closeConnection(conn);

		request.setAttribute("cId", employee.toString());
		request.setAttribute("Exception", exception);

		forward(request, response, "/servlet/timectrl/employee/TurnsOfEmployee");

	}

}
