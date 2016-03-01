package cl.buildersoft.web.servlet.timectrl.employee;

import java.io.IOException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.util.BSDateTimeUtil;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.business.beans.Area;
import cl.buildersoft.timectrl.business.beans.Employee;
import cl.buildersoft.timectrl.business.beans.EmployeeTurn;
import cl.buildersoft.timectrl.business.beans.Post;
import cl.buildersoft.timectrl.business.beans.Turn;
import cl.buildersoft.timectrl.business.services.EmployeeTurnService;
import cl.buildersoft.timectrl.business.services.impl.EmployeeTurnServiceImpl;

/**
 * Servlet implementation class Turns
 */
@WebServlet("/servlet/timectrl/employee/TurnsOfEmployee")
public class TurnsOfEmployee extends BSHttpServlet {
	private static final long serialVersionUID = 2424628512723044632L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		BSBeanUtils bu = new BSBeanUtils();
		// BSmySQL mysql = new BSmySQL();
		// BSDateTimeUtil du = new BSDateTimeUtil();

		Connection conn = getConnection(request);
		Employee employee = getEmployee(request, bu, conn);
		Post post = getPostEmployee(conn, bu, employee);
		Area area = getAreaEmployee(conn, bu, employee);
		Boolean exception = getException(request);
		List<EmployeeTurn> tempTurns = getEmployeeTurns(conn, employee);

		List<EmployeeTurn> employeeTurns = new ArrayList<EmployeeTurn>();
		List<EmployeeTurn> exceptionTurns = new ArrayList<EmployeeTurn>();

		for (EmployeeTurn current : tempTurns) {
			if (current.getException()) {
				exceptionTurns.add(current);
			} else {
				employeeTurns.add(current);
			}
		}

		String dateFormat = BSDateTimeUtil.getFormatDate(conn);
		List<Turn> turns = getTurns(conn);

		String page = bootstrap(conn) ? "/WEB-INF/jsp/timectrl/employee/turns-of-employee2.jsp"
				: "/WEB-INF/jsp/timectrl/employee/turns-of-employee.jsp";
		closeConnection(conn);

		request.setAttribute("Employee", employee);
		request.setAttribute("Post", post);
		request.setAttribute("Area", area);
		request.setAttribute("EmployeeTurn", employeeTurns);
		request.setAttribute("ExceptionTurn", exceptionTurns);
		request.setAttribute("DateFormat", dateFormat);
		request.setAttribute("Turns", turns);

		forward(request, response, page);
		// request.getRequestDispatcher(page).forward(request, response);
	}

	private Boolean getException(HttpServletRequest request) {
		Object mayBeException = request.getAttribute("Exception");
		Boolean out = mayBeException != null ? Boolean.parseBoolean(mayBeException.toString()) : false;
		return out;
	}

	@SuppressWarnings("unchecked")
	private List<Turn> getTurns(Connection conn) {
		Turn area = new Turn();

		BSBeanUtils bu = new BSBeanUtils();
		List<Turn> out = (List<Turn>) bu.listAll(conn, area);

		return out;
	}

	private List<EmployeeTurn> getEmployeeTurns(Connection conn, Employee employee) {
		EmployeeTurnService service = new EmployeeTurnServiceImpl();
		return service.listAllEmployeeTurns(conn, employee.getId());
	}

	// private List<EmployeeTurn> getTurns(Connection conn, BSBeanUtils bu,
	// Employee employee) throws BSDataBaseException {
	// ResultSet turnsRS = bu.queryResultSet(conn,
	// "SELECT cTurn, cStartDate, cEndDate FROM tR_EmployeeTurn WHERE cEmployee=?",
	// employee.getId());
	// // EmployeeTurn employeeTurn = new EmployeeTurn();
	//
	// List<EmployeeTurn> out = new ArrayList<EmployeeTurn>();
	//
	// try {
	// EmployeeTurn employeeTurn = null;
	//
	// while (turnsRS.next()) {
	// employeeTurn = new EmployeeTurn();
	// employeeTurn.setEmployee(employee.getId());
	// employeeTurn.setTurn(turnsRS.getLong("cTurn"));
	//
	// employeeTurn.setStartDate(BSDateTimeUtil.date2Calendar(turnsRS.getDate("cStartDate")));
	// employeeTurn.setEndDate(BSDateTimeUtil.date2Calendar(turnsRS.getDate("cEndDate")));
	//
	// out.add(employeeTurn);
	//
	// }
	// } catch (SQLException e) {
	// throw new BSDataBaseException(e);
	// }
	// // turn.setId(employee.getArea());
	// // List<Turn> turn = bu.list(conn, bean, where, parameters)(conn, turn);
	// return out;
	// }

	private Area getAreaEmployee(Connection conn, BSBeanUtils bu, Employee employee) {
		Area area = new Area();
		area.setId(employee.getArea());
		bu.search(conn, area);
		return area;

	}

	private Post getPostEmployee(Connection conn, BSBeanUtils bu, Employee employee) {
		Post post = new Post();
		post.setId(employee.getPost());
		bu.search(conn, post);
		return post;
	}

	private Employee getEmployee(HttpServletRequest request, BSBeanUtils bu, Connection conn) {
		Long id = Long.parseLong(getEmployeeId(request));
		Employee employee = new Employee();
		employee.setId(id);

		bu.search(conn, employee);
		return employee;
	}

	private String getEmployeeId(HttpServletRequest request) {
		String out = null;

		Object idObject = request.getAttribute("cId");
		if (idObject != null) {
			out = (String) idObject;
		} else {
			out = request.getParameter("cId");
		}
		return out;
		// return request.getParameter("cId");
	}

}
