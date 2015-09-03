package cl.buildersoft.web.servlet.timectrl.report.execute;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.business.beans.Employee;

/**
 * Servlet implementation class ListEmployeeAjax
 */
@WebServlet("/servlet/timectrl/report/execute/ListEmployeeAjax")
public class ListEmployeeAjax extends BSHttpServlet {

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String rut = request.getParameter("Rut");
		String name = request.getParameter("Name");

		if (rut == null) {
			rut = "";
		}
		if (name == null) {
			name = "";
		}

		BSBeanUtils bu = new BSBeanUtils();

		Connection conn = getConnection(request);

		String where = null;
		String[] params = null;

		if (rut.length() == 0 && name.length() == 0) {
			where = "";
			params = new String[0];
		} else if (rut.length() > 0 && name.length() == 0) {
			where = "cRut=?";
			params = new String[1];
			params[0] = rut;
		} else if (rut.length() > 0 && name.length() > 0) {
			where = "cRut=? OR cName=?";
			params = new String[2];
			params[0] = rut;
			params[1] = name;
		} else if (rut.length() == 0 && name.length() > 0) {
			where = "cName=?";
			params = new String[1];
			params[0] = name;
		}

		List<Employee> list = (List<Employee>) bu.list(conn, new Employee(), where, params);
		request.setAttribute("EmployeeList", list);
		
		forward(request, response, "/WEB-INF/jsp/timectrl/report/execute/params/list-employees.jsp");

	}
}
