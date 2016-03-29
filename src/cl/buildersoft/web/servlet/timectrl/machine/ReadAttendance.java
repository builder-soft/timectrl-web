package cl.buildersoft.web.servlet.timectrl.machine;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.util.BSConfig;
import cl.buildersoft.framework.web.servlet.BSHttpServlet_;
import cl.buildersoft.timectrl.api.IZKEMException;
import cl.buildersoft.timectrl.api._zkemProxy;
import cl.buildersoft.timectrl.business.beans.AttendanceLog;
import cl.buildersoft.timectrl.business.beans.Machine;
import cl.buildersoft.timectrl.business.services.MachineService2;
import cl.buildersoft.timectrl.business.services.impl.MachineServiceImpl2;

/**
 * Servlet implementation class ReadAttendance
 */
@WebServlet("/servlet/timectrl/machine/ReadAttendance")
public class ReadAttendance extends BSHttpServlet_ {
	private static final long serialVersionUID = 31499791488695127L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		MachineService2 machineService = new MachineServiceImpl2();
		BSBeanUtils bu = new BSBeanUtils();

		Connection conn = getConnection(request);
		String dateFormat = getDateTimeFormat(conn);
		Machine machine = getMachine(conn, bu, request);

		_zkemProxy api = machineService.connect(conn, machine);
		List<AttendanceLog> list = null;
		try {
			list = machineService.listAttendence(conn, api, machine);
		} catch (IZKEMException e) {
			e.printStackTrace();
		} finally {
			machineService.disconnect(api);
		}

		String page = bootstrap(conn) ? "/WEB-INF/jsp/timectrl/machine/read-attendance2.jsp"
				: "/WEB-INF/jsp/timectrl/machine/read-attendance.jsp";

		closeConnection(conn);

		request.setAttribute("Attendances", list);
		request.setAttribute("Machine", machine);
		request.setAttribute("DateTimeFormat", dateFormat);
		setSessionValue(request, "Attendances", list);
		// request.getSession(false).setAttribute("Attendances", list);

		forward(request, response, page);
	}

	private String getDateTimeFormat(Connection conn) {
		return (new BSConfig()).getString(conn, "FORMAT_DATETIME");
	}

	private Machine getMachine(Connection conn, BSBeanUtils bu, HttpServletRequest request) {
		Long id = Long.parseLong(request.getParameter("cId"));
		Machine out = new Machine();
		out.setId(id);

		bu.search(conn, out);

		return out;
	}

}
