package cl.buildersoft.web.servlet.timectrl.machine;

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
import cl.buildersoft.timectrl.business.beans.Privilege;

/**
 * Servlet implementation class ListEmployeeByArea
 */
@WebServlet("/servlet/timectrl/machine/ListEmployeeByArea")
public class ListEmployeeByArea extends BSHttpServlet {
	private static final long serialVersionUID = 6918804998890181213L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long area = Long.parseLong(request.getParameter("Area"));

		BSBeanUtils bu = new BSBeanUtils();
		Connection conn = getConnection(request);

		List<Employee> listEmployee = (List<Employee>) bu.list(conn, new Employee(), "cArea=?", area);
		List<Privilege> privilegeList = (List<Privilege>) bu.listAll(conn, new Privilege());

//		updatePrivilege(listEmployee, privilegeList);

		request.setAttribute("PrivilegeList", privilegeList);
		request.setAttribute("Employee", listEmployee);

		forward(request, response, "/WEB-INF/jsp/timectrl/machine/list-employee-by-area.jsp");
	}

	private void updatePrivilege(List<Employee> employeeList, List<Privilege> privilegeList) {
		// Debe actualizar el privilegio del empleado,
		// buscando el Id en la lista para dejar el Key
		Integer privilegeKey = null;
		for (Employee employee : employeeList) {
			privilegeKey = getPrivilegeKey(employee, privilegeList);
			employee.setPrivilege(privilegeKey.longValue());
		}
	}

	private Integer getPrivilegeKey(Employee employee, List<Privilege> privilegeList) {
		Long privilegeId = employee.getPrivilege();
		Integer privilegeKey = null;
		for (Privilege privilege : privilegeList) {
			if (privilege.getId().equals(privilegeId)) {
				privilegeKey = privilege.getKey();
			}
		}

		return privilegeKey;
	}
}
