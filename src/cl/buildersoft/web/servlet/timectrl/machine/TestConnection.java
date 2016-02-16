package cl.buildersoft.web.servlet.timectrl.machine;

import java.io.IOException;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.exception.BSConfigurationException;
import cl.buildersoft.framework.util.BSConnectionFactory;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.api._zkemProxy;
import cl.buildersoft.timectrl.business.beans.Machine;
import cl.buildersoft.timectrl.business.services.MachineService2;
import cl.buildersoft.timectrl.business.services.impl.MachineServiceImpl2;

/**
 * Servlet implementation class Ping
 */
@WebServlet("/servlet/timectrl/machine/TestConnection")
public class TestConnection extends BSHttpServlet {
	private static final Logger LOG = Logger.getLogger(TestConnection.class.getName());
	private static final long serialVersionUID = -6238788213123204507L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String[] ids = request.getParameterValues("cId");
		MachineService2 machineService = new MachineServiceImpl2();
		Machine machine = null;
		BSBeanUtils bu = new BSBeanUtils();
		BSConnectionFactory cf = new BSConnectionFactory();
		Connection conn = cf.getConnection(request);

		Map<Machine, Boolean> status = new HashMap<Machine, Boolean>();
		for (String id : ids) {

			machine = new Machine();
			machine.setId(Long.parseLong(id));
			bu.search(conn, machine);
			_zkemProxy api = null;

			try {
				api = machineService.connect(conn, machine);
				machineService.disconnect(api);
			} catch (BSConfigurationException e) {
				LOG.log(Level.SEVERE, e.getMessage(), e);
			}

			status.put(machine, api != null);

		}

		String page = bootstrap(conn) ? "/WEB-INF/jsp/timectrl/machine/test-connection2.jsp"
				: "/WEB-INF/jsp/timectrl/machine/test-connection.jsp";

		cf.closeConnection(conn);
		request.setAttribute("Status", status);

		forward(request, response, page);

	}
}
