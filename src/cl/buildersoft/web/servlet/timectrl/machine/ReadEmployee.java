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
import cl.buildersoft.framework.util.BSConfig;
import cl.buildersoft.framework.util.BSConnectionFactory;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.api._zkemProxy;
import cl.buildersoft.timectrl.business.beans.Area;
import cl.buildersoft.timectrl.business.beans.Employee;
import cl.buildersoft.timectrl.business.beans.Fingerprint;
import cl.buildersoft.timectrl.business.beans.Machine;
import cl.buildersoft.timectrl.business.beans.Privilege;
import cl.buildersoft.timectrl.business.services.MachineService2;
import cl.buildersoft.timectrl.business.services.impl.EmployeeAndFingerprint;
import cl.buildersoft.timectrl.business.services.impl.MachineServiceImpl2;

/**
 * Servlet implementation class ReadEmployee
 */
@WebServlet("/servlet/timectrl/machine/ReadEmployee")
public class ReadEmployee extends BSHttpServlet {
	private static final long serialVersionUID = 4736128480177088600L;

	@SuppressWarnings("unchecked")
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long id = Long.parseLong(readParameterOrAttribute(request, "cId"));
		Machine machine = new Machine();
		MachineService2 machineService = new MachineServiceImpl2();

		BSBeanUtils bu = new BSBeanUtils();
		BSConnectionFactory cf = new BSConnectionFactory();
		Connection conn = cf.getConnection(request);

		machine.setId(id);
		bu.search(conn, machine);

		_zkemProxy api = machineService.connect(conn, machine);
		List<EmployeeAndFingerprint> eaf = machineService.listEmployees(conn, api);

		machineService.disconnect(api);

		List<Area> areaList = null;
		if (getReadArea(conn)) {
			areaList = (List<Area>) bu.listAll(conn, new Area());
		}

		List<EmployeeAndFingerprint> employeeDB = listEmployeeListDB(conn, areaList);
		List<Privilege> privilegeList = (List<Privilege>) bu.listAll(conn, new Privilege());
		// updatePrivilege(employeeDB, privilegeList);

		request.setAttribute("EAFListMch", eaf);
		request.setAttribute("EAFListDB", employeeDB);
		request.setAttribute("AreaList", areaList);
		request.setAttribute("Machine", machine);
		request.setAttribute("PrivilegeList", privilegeList);

		String page = bootstrap(conn)?"/WEB-INF/jsp/timectrl/machine/read-employee2.jsp":  "/WEB-INF/jsp/timectrl/machine/read-employee.jsp";
		
		cf.closeConnection(conn);

		forward(request, response, page);
	}

	/**
	 * <code>
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
</code>
	 */

	private Boolean getReadArea(Connection conn) {
		BSConfig config = new BSConfig();
		return config.getBoolean(conn, "AREA_FILTER");
	}

	@SuppressWarnings("unchecked")
	private List<EmployeeAndFingerprint> listEmployeeListDB(Connection conn, List<Area> areas) {
		BSBeanUtils bu = new BSBeanUtils();
		List<EmployeeAndFingerprint> out = new ArrayList<EmployeeAndFingerprint>();
		List<Employee> employeeList = null;
		if (areas == null || areas.size() == 0) {
			employeeList = (List<Employee>) bu.listAll(conn, new Employee());
		} else {
			employeeList = (List<Employee>) bu.list(conn, new Employee(), "cArea=?", areas.get(0).getId());
		}

		Fingerprint fingerprint = null;
		for (Employee employee : employeeList) {
			fingerprint = new Fingerprint();
			EmployeeAndFingerprint eaf = new EmployeeAndFingerprint();
			bu.search(conn, fingerprint, "cEmployee=?", employee.getId());

			eaf.setEmployee(employee);
			eaf.setFingerprint(fingerprint);

			out.add(eaf);

		}

		return out;
	}
}