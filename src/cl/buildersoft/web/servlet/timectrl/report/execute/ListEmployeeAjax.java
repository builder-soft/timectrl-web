package cl.buildersoft.web.servlet.timectrl.report.execute;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.util.BSConnectionFactory;
import cl.buildersoft.framework.web.servlet.BSHttpServlet_;
import cl.buildersoft.timectrl.business.beans.Employee;

@WebServlet("/servlet/timectrl/report/execute/ListEmployeeAjax")
public class ListEmployeeAjax extends BSHttpServlet_ {
	private static final long serialVersionUID = Long.MAX_VALUE - Long.MIN_VALUE;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String rut = request.getParameter("Rut");
		String name = request.getParameter("Name");
		String type = request.getParameter("Type");

		if (rut == null) {
			rut = "";
		}
		if (name == null) {
			name = "";
		}
		if (type == null) {
			type = "Employee";
		}

		rut = rut.trim();
		name = name.trim();

		if ("employee".equalsIgnoreCase(type) || "boss".equalsIgnoreCase(type)) {
			listEmployeeOrBoss(request, rut, name, type);
		}

		forward(request, response, "/WEB-INF/jsp/timectrl/report/execute/params/list-employees-json.jsp");

	}

	@SuppressWarnings("unchecked")
	private void listEmployeeOrBoss(HttpServletRequest request, String rut, String name, String type) {
		BSBeanUtils bu = new BSBeanUtils();
		List<Employee> list = null;

		String where = null;
		String[] params = null;

		if (rut.length() == 0 && name.length() == 0) {
			where = null;
			params = null; // new String[0];
		} else if (rut.length() > 0 && name.length() == 0) {
			where = "cRut LIKE ?";
			params = new String[1];
			params[0] = rut + "%";
		} else if (rut.length() > 0 && name.length() > 0) {
			where = "cRut LIKE ? AND cName LIKE ?";
			params = new String[2];
			params[0] = rut + "%";
			params[1] = "%" + name + "%";
		} else if (rut.length() == 0 && name.length() > 0) {
			where = "cName LIKE ?";
			params = new String[1];
			params[0] = "%" + name + "%";
		}

		if ("boss".equalsIgnoreCase(type)) {
			where = (where == null ? "" : where + " AND ");
			where += "cId IN (SELECT DISTINCT(cBoss) FROM tEmployee WHERE NOT cBoss IS NULL AND cEnabled=TRUE)";
		}

		/**
		 * <code>
		if(where == null){
			where = " cEnabled = TRUE ";
		}else{
			where += " AND cEnabled = TRUE ";
		}
		</code>
		 */

		if (where != null) {
			where += " AND ";
		} else {
			where = "";
		}
		where += " cEnabled = TRUE ";

		BSConnectionFactory cf = new BSConnectionFactory();
		Connection conn = cf.getConnection(request);
		list = (List<Employee>) bu.list(conn, new Employee(), where, params);
		cf.closeConnection(conn);

		request.setAttribute("EmployeeList", list);
		request.setAttribute("Type", type);
	}
}
