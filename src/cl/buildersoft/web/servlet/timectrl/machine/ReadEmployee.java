package cl.buildersoft.web.servlet.timectrl.machine;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.util.BSConfig;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.api._zkemProxy;
import cl.buildersoft.timectrl.business.beans.Area;
import cl.buildersoft.timectrl.business.beans.Employee;
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
		Connection conn = getConnection(request);

		machine.setId(id);
		bu.search(conn, machine);

		_zkemProxy api = machineService.connect(conn, machine);
		List<EmployeeAndFingerprint> eaf = machineService.listEmployees(conn, api);

		machineService.disconnect(api);

		List<Area> areaList = null;
		if (getReadArea(conn)) {
			areaList = (List<Area>) bu.listAll(conn, new Area());
		}

		List<Employee> employeeDB = listEmployeeListDB(conn, areaList);
		List<Privilege> privilegeList = (List<Privilege>) bu.listAll(conn, new Privilege());
//		updatePrivilege(employeeDB, privilegeList);

		request.setAttribute("EAFList", eaf);
		request.setAttribute("EmployeeListDB", employeeDB);
		request.setAttribute("AreaList", areaList);
		request.setAttribute("Machine", machine);
		request.setAttribute("PrivilegeList", privilegeList);

		new BSmySQL().closeConnection(conn);

		request.getRequestDispatcher("/WEB-INF/jsp/timectrl/machine/read-employee.jsp").forward(request, response);
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

	private Boolean getReadArea(Connection conn) {
		BSConfig config = new BSConfig();
		return config.getBoolean(conn, "AREA_FILTER");
	}

	@SuppressWarnings("unchecked")
	private List<Employee> listEmployeeListDB(Connection conn, List<Area> areas) {
		BSBeanUtils bu = new BSBeanUtils();
		List<Employee> out = null;
		if (areas == null || areas.size() == 0) {
			out = (List<Employee>) bu.listAll(conn, new Employee());
		} else {
			out = (List<Employee>) bu.list(conn, new Employee(), "cArea=?", areas.get(0).getId());
		}
		return out;
	}
}