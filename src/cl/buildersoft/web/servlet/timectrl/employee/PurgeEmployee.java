package cl.buildersoft.web.servlet.timectrl.employee;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.web.servlet.BSHttpServlet_;

/**
 * Servlet implementation class PurgeEmployee
 */
@WebServlet("/servlet/timectrl/employee/PurgeEmployee")
public class PurgeEmployee extends BSHttpServlet_ {
	private static final long serialVersionUID = PurgeEmployee.class.getName().hashCode();

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		forward(request, response, "/servlet/config/employee/EmployeeDetachedManager");
	}

}
