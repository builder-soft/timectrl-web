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

@WebServlet("/servlet/timectrl/report/execute/ListEmployeeAjax")
public class ListEmployeeAjax extends BSHttpServlet {
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
		}else{
			
		}

		forward(request, response, "/WEB-INF/jsp/timectrl/report/execute/params/list-employees-json.jsp");

	}

	private void listEmployeeOrBoss(HttpServletRequest request, String rut, String name, String type) {
		BSBeanUtils bu = new BSBeanUtils();
		Connection conn = getConnection(request);

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
			params[1] = name + "%";
		} else if (rut.length() == 0 && name.length() > 0) {
			where = "cName LIKE ?";
			params = new String[1];
			params[0] = name + "%";
		}
		
		if("boss".equalsIgnoreCase(type)){
			where = (where ==null? " cBoss":where);
		}
		

		List<Employee> list = (List<Employee>) bu.list(conn, new Employee(), where, params);
		request.setAttribute("EmployeeList", list);
		request.setAttribute("Type", type);
	}
}
