package cl.buildersoft.web.servlet.timectrl.machine;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.util.BSConnectionFactory;
import cl.buildersoft.framework.web.servlet.BSHttpServlet_;
import cl.buildersoft.timectrl.api.com4j._zkemProxy;
import cl.buildersoft.timectrl.business.beans.Machine;
import cl.buildersoft.timectrl.business.services.MachineService2;
import cl.buildersoft.timectrl.business.services.impl.MachineServiceImpl2;

/**
 * Servlet implementation class DeleteEmployee
 */
@WebServlet("/servlet/timectrl/machine/DeleteEmployee")
public class DeleteEmployee extends BSHttpServlet_ {
	private static final long serialVersionUID = 8751209270314151392L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String[] keys = request.getParameterValues("cKey");
		Long machineId = Long.parseLong(request.getParameter("Machine"));

		BSBeanUtils bu = new BSBeanUtils();
		BSConnectionFactory cf = new BSConnectionFactory();
		Connection conn = cf.getConnection(request);

		Machine machine = new Machine();
		machine.setId(machineId);
		bu.search(conn, machine);

		MachineService2 machineService = new MachineServiceImpl2();
		_zkemProxy api = machineService.connect(conn, machine);
		cf.closeConnection(conn);

		if (keys != null) {
			machineService.deleteEmployees(api, keys);
		}
		machineService.disconnect(api);
		forward(request, response, "/servlet/timectrl/machine/MachineManager");

	}

}
