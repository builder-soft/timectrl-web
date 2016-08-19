package cl.buildersoft.web.servlet.timectrl.machine;

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
import cl.buildersoft.timectrl.business.beans.Privilege;
import cl.buildersoft.timectrl.business.services.EmployeeService;
import cl.buildersoft.timectrl.business.services.impl.EmployeeAndFingerprint;
import cl.buildersoft.timectrl.business.services.impl.EmployeeServiceImpl;

/**
 * Servlet implementation class ListEmployeeByArea
 */
@WebServlet("/servlet/timectrl/machine/ListEmployeeByArea")
public class ListEmployeeByArea extends BSHttpServlet_ {
	private static final long serialVersionUID = 6918804998890181213L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long area = Long.parseLong(request.getParameter("Area"));

		BSBeanUtils bu = new BSBeanUtils();
		BSConnectionFactory cf = new BSConnectionFactory();
		Connection conn = cf.getConnection(request);

		EmployeeService es = new EmployeeServiceImpl();
		
		List<Employee > employeeList = (List<Employee>) bu.list(conn, new Employee(), "cArea=?", area);
		
		List<EmployeeAndFingerprint> listEmployee = es.fillFingerprint(conn, employeeList);
		
		
		List<Privilege> privilegeList = (List<Privilege>) bu.listAll(conn, new Privilege());
		cf.closeConnection(conn);

		// updatePrivilege(listEmployee, privilegeList);

		request.setAttribute("PrivilegeList", privilegeList);
		request.setAttribute("EmployeeAndFingerprint", listEmployee);

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
