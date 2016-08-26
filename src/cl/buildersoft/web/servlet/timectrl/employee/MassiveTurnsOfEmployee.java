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
import cl.buildersoft.framework.web.servlet.BSHttpServlet_;
import cl.buildersoft.timectrl.business.beans.Employee;
import cl.buildersoft.timectrl.business.beans.Turn;

/**
 * Servlet implementation class Turns
 */
@WebServlet("/servlet/timectrl/employee/MassiveTurnsOfEmployee")
public class MassiveTurnsOfEmployee extends BSHttpServlet_ {
	private static final long serialVersionUID = MassiveTurnsOfEmployee.class.getName().hashCode();

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		BSBeanUtils bu = new BSBeanUtils();

		Connection conn = getConnection(request);
		List<Employee> employeeList = getEmployee(request, bu, conn);
		// Post post = getPostEmployee(conn, bu, employee);
		// Area area = getAreaEmployee(conn, bu, employee);
		// List<EmployeeTurn> tempTurns = getEmployeeTurns(conn, employee);

//		List<EmployeeTurn> employeeTurns = new ArrayList<EmployeeTurn>();
//		List<EmployeeTurn> exceptionTurns = new ArrayList<EmployeeTurn>();
//
//		for (EmployeeTurn current : tempTurns) {
//			if (current.getException()) {
//				exceptionTurns.add(current);
//			} else {
//				employeeTurns.add(current);
//			}
//		}

		String dateFormat = BSDateTimeUtil.getFormatDate(conn);
		List<Turn> turns = getTurns(conn);

		String page = "/WEB-INF/jsp/timectrl/employee/massive-turns-of-employee2.jsp";
		closeConnection(conn);

		request.setAttribute("EmployeeList", employeeList);
//		request.setAttribute("Post", post);
//		request.setAttribute("Area", area);
//		request.setAttribute("EmployeeTurn", employeeTurns);
//		request.setAttribute("ExceptionTurn", exceptionTurns);
		request.setAttribute("DateFormat", dateFormat);
		request.setAttribute("Turns", turns);

		forward(request, response, page);
	}

	@SuppressWarnings("unchecked")
	private List<Turn> getTurns(Connection conn) {
		Turn area = new Turn();

		BSBeanUtils bu = new BSBeanUtils();
		List<Turn> out = (List<Turn>) bu.listAll(conn, area);

		return out;
	}
/**<code>
	private List<EmployeeTurn> getEmployeeTurns(Connection conn, Employee employee) {
		EmployeeTurnService service = new EmployeeTurnServiceImpl();
		return service.listAllEmployeeTurns(conn, employee.getId());
	}

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
</code>*/
	
	private List<Employee> getEmployee(HttpServletRequest request, BSBeanUtils bu, Connection conn) {
		List<Employee> out = new ArrayList<Employee>();

		String[] ids = getEmployeeId(request);

		for (String id : ids) {
			Employee employee = new Employee();
			employee.setId(Long.parseLong(id));

			if (bu.search(conn, employee)) {
				out.add(employee);
			}

		}

		// Long id = Long.parseLong();
		// Employee employee = new Employee();
		// employee.setId(id);
		//
		// bu.search(conn, employee);
		return out;
	}

	private String[] getEmployeeId(HttpServletRequest request) {
		String[] out = null;

		out = request.getParameterValues("cId");

		return out;
	}

}
