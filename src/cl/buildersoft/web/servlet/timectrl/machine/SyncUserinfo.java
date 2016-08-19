package cl.buildersoft.web.servlet.timectrl.machine;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.web.servlet.BSHttpServlet_;
import cl.buildersoft.timectrl.api.com4j._zkemProxy;
import cl.buildersoft.timectrl.business.beans.Machine;
import cl.buildersoft.timectrl.business.services.MachineService2;
import cl.buildersoft.timectrl.business.services.impl.MachineServiceImpl2;

/**
 * Servlet implementation class SyncUserinfo
 */
@WebServlet("/servlet/timectrl/machine/SyncUserinfo")
public class SyncUserinfo extends BSHttpServlet_ {
	private static final long serialVersionUID = 662776837866166715L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String[] keys = request.getParameterValues("cKey");
		Long machineId = Long.parseLong(request.getParameter("Machine"));

		BSBeanUtils bu = new BSBeanUtils();
		Connection conn = getConnection(request);

		Machine machine = new Machine();
		machine.setId(machineId);
		bu.search(conn, machine);

		// IZKEM api = ClassFactory.createCZKEM(conn);

		MachineService2 machineService = new MachineServiceImpl2();
		_zkemProxy api = machineService.connect(conn, machine);

		if (keys != null) {
			machineService.syncEmployees(conn, api, keys);
		}
		// bu.closeConnection(conn);
		machineService.disconnect(api);

		request.setAttribute("cId", machineId.toString());
		forward(request, response, "/servlet/timectrl/machine/ReadEmployee");

	}
}
