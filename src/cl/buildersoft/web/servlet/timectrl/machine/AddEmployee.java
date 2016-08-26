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
import cl.buildersoft.framework.web.servlet.BSHttpServlet_;
import cl.buildersoft.timectrl.api.com4j._zkemProxy;
import cl.buildersoft.timectrl.business.beans.Employee;
import cl.buildersoft.timectrl.business.beans.Fingerprint;
import cl.buildersoft.timectrl.business.beans.Machine;
import cl.buildersoft.timectrl.business.services.MachineService2;
import cl.buildersoft.timectrl.business.services.PrivilegeService;
import cl.buildersoft.timectrl.business.services.impl.EmployeeAndFingerprint;
import cl.buildersoft.timectrl.business.services.impl.MachineServiceImpl2;
import cl.buildersoft.timectrl.business.services.impl.PrivilegeServiceImpl;

/**
 * Servlet implementation class AddEmployee
 */
@WebServlet("/servlet/timectrl/machine/AddEmployee")
public class AddEmployee extends BSHttpServlet_ {
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
			List<EmployeeAndFingerprint> employees = getEmployeeList(conn, keys);
			PrivilegeService ps = new PrivilegeServiceImpl();
			machineService.addEmployees(conn, ps, api, employees);
			machineService.disconnect(api);
		}

		forward(request, response, "/servlet/timectrl/machine/MachineManager");
	}

	private List<EmployeeAndFingerprint> getEmployeeList(Connection conn, String[] keys) {
		List<EmployeeAndFingerprint> out = new ArrayList<EmployeeAndFingerprint>();
		BSBeanUtils bu = new BSBeanUtils();
		Employee employee = null;
		Fingerprint fingerprint = null;
		EmployeeAndFingerprint eaf = null;

		for (String key : keys) {
			employee = new Employee();
			fingerprint = new Fingerprint();

			bu.search(conn, employee, "cKey=?", key);
			bu.search(conn, fingerprint, "cEmployee=?", employee.getId());

			eaf = new EmployeeAndFingerprint();
			eaf.setEmployee(employee);
			eaf.setFingerprint(fingerprint);

			out.add(eaf);
		}

		return out;
	}
}
