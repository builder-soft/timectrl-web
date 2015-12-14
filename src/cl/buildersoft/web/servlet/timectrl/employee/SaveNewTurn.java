package cl.buildersoft.web.servlet.timectrl.employee;

import java.io.IOException;
import java.sql.Connection;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.util.BSDateTimeUtil;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.business.beans.EmployeeTurn;
import cl.buildersoft.timectrl.business.services.EmployeeTurnService;
import cl.buildersoft.timectrl.business.services.impl.EmployeeTurnServiceImpl;

/**
 * Servlet implementation class SaveNewTurn
 */
@WebServlet("/servlet/timectrl/employee/SaveNewTurn")
public class SaveNewTurn extends BSHttpServlet {
	private static final long serialVersionUID = 3010813754466559516L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long employee = Long.parseLong(request.getParameter("Employee"));
		Long turn = Long.parseLong(request.getParameter("Turn"));
		String start = request.getParameter("StartDate");
		String end = request.getParameter("EndDate");

		String turnId = request.getParameter("TurnId");
		Connection conn = getConnection(request);
		String formatDate = BSDateTimeUtil.getFormatDate(conn);

		Calendar startDate = BSDateTimeUtil.string2Calendar(start, formatDate);
		Calendar endDate = BSDateTimeUtil.string2Calendar(end, formatDate);

		EmployeeTurn employeeTurn = new EmployeeTurn();
		if (turnId.length() > 0) {
			Long turnIdAsLong = Long.parseLong(turnId);
			employeeTurn.setId(turnIdAsLong);
			employeeTurn.setTurn(turn);
			employeeTurn.setStartDate(startDate);
			employeeTurn.setEndDate(endDate);

			EmployeeTurnService service = new EmployeeTurnServiceImpl();
			service.update(conn, employeeTurn);
		} else {
			employeeTurn.setEmployee(employee);
			employeeTurn.setTurn(turn);
			employeeTurn.setStartDate(startDate);
			employeeTurn.setEndDate(endDate);

			EmployeeTurnService service = new EmployeeTurnServiceImpl();
			service.appendNew(conn, employeeTurn);
		}
		closeConnection(conn);

		request.setAttribute("cId", employee.toString());

		forward(request, response, "/servlet/timectrl/employee/TurnsOfEmployee");

	}

}
