package cl.buildersoft.web.servlet.timectrl.machine;

import java.io.IOException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.api._zkemProxy;
import cl.buildersoft.timectrl.business.beans.Employee;
import cl.buildersoft.timectrl.business.beans.Machine;
import cl.buildersoft.timectrl.business.services.MachineService2;
import cl.buildersoft.timectrl.business.services.PrivilegeService;
import cl.buildersoft.timectrl.business.services.impl.MachineServiceImpl2;
import cl.buildersoft.timectrl.business.services.impl.PrivilegeServiceImpl;

/**
 * Servlet implementation class AddEmployee
 */
@WebServlet("/servlet/timectrl/machine/AddEmployee")
public class AddEmployee extends BSHttpServlet {
	private static final long serialVersionUID = -514331423472719202L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String[] keys = request.getParameterValues("cKey");
		Long machineId = Long.parseLong(request.getParameter("Machine"));

		if (keys != null) {
			BSBeanUtils bu = new BSBeanUtils();
			Connection conn = getConnection(request);

			Machine machine = new Machine();
			machine.setId(machineId);
			bu.search(conn, machine);

			MachineService2 machineService = new MachineServiceImpl2();
			_zkemProxy api = machineService.connect(conn, machine);
			List<Employee> employees = getEmployeeList(conn, keys);
			PrivilegeService ps = new PrivilegeServiceImpl();
			machineService.addEmployees(conn, ps, api, employees);
			machineService.disconnect(api);
		}

		forward(request, response, "/servlet/timectrl/machine/MachineManager");
	}

	private List<Employee> getEmployeeList(Connection conn, String[] keys) {
		List<Employee> out = new ArrayList<Employee>();
		BSBeanUtils bu = new BSBeanUtils();
		Employee employee = null;

		for (String key : keys) {
			employee = new Employee();
			bu.search(conn, employee, "cKey=?", key);

			out.add(employee);
		}

		return out;
	}
}
