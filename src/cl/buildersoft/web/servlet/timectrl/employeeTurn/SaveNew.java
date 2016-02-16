package cl.buildersoft.web.servlet.timectrl.employeeTurn;

import java.io.IOException;
import java.sql.Connection;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.util.BSConnectionFactory;
import cl.buildersoft.framework.util.BSDateTimeUtil;
import cl.buildersoft.timectrl.business.beans.EmployeeTurn;
import cl.buildersoft.timectrl.business.services.EmployeeTurnService;
import cl.buildersoft.timectrl.business.services.impl.EmployeeTurnServiceImpl;

/**
 * Servlet implementation class SaveNew
 */
@WebServlet("/servlet/timectrl/employeeTurn/SaveNew")
public class SaveNew extends HttpServlet {
	private static final long serialVersionUID = 3010813754466559516L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long employee = Long.parseLong(request.getParameter("Employee"));
		Long turn = Long.parseLong(request.getParameter("Turn"));
		String start = request.getParameter("StartDate");
		String end = request.getParameter("EndDate");

		Calendar startDate = BSDateTimeUtil.string2Calendar(start, "yyyy-MM-dd");
		Calendar endDate = BSDateTimeUtil.string2Calendar(end, "yyyy-MM-dd");

		EmployeeTurn employeeTurn = new EmployeeTurn();
		employeeTurn.setEmployee(employee);
		employeeTurn.setTurn(turn);
		employeeTurn.setStartDate(startDate);
		employeeTurn.setEndDate(endDate);

		BSConnectionFactory cf = new BSConnectionFactory();
		Connection conn = cf.getConnection(request);

		EmployeeTurnService service = new EmployeeTurnServiceImpl();
		service.appendNew(conn, employeeTurn);
		cf.closeConnection(conn);

		request.setAttribute("cId", employee.toString());

		request.getRequestDispatcher("/servlet/timectrl/employeeTurn/TurnsOfEmployee").forward(request, response);

	}

}
