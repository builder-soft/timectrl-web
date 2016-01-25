package cl.buildersoft.web.servlet.timectrl.machine;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.exception.BSException;
import cl.buildersoft.framework.util.BSConnectionFactory;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.api._zkemProxy;
import cl.buildersoft.timectrl.business.beans.AttendanceLog;
import cl.buildersoft.timectrl.business.beans.Machine;
import cl.buildersoft.timectrl.business.services.MachineService2;
import cl.buildersoft.timectrl.business.services.impl.MachineServiceImpl2;

/**
 * Servlet implementation class SaveAttendanceToDataBase
 */
@WebServlet("/servlet/timectrl/machine/SaveAttendanceToDataBase")
public class SaveAttendanceToDataBase extends BSHttpServlet {
	private static final String ATTENDANCES = "Attendances";
	private static final long serialVersionUID = 4061684288079220007L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		@SuppressWarnings("unchecked")
		List<AttendanceLog> attendanceList = (List<AttendanceLog>) session.getAttribute(ATTENDANCES);

		// BSBeanUtils bu = new BSBeanUtils();
		BSConnectionFactory cf = new BSConnectionFactory();
		Connection conn = cf.getConnection(request);
		Machine machine = getMachine(conn, request);
		// BSmySQL mysql = new BSmySQL();
		MachineService2 service = new MachineServiceImpl2();
		Integer noSavedCount = 0;

		for (AttendanceLog attendance : attendanceList) {
			if (!service.existsAttendanceLog(conn, attendance)) {
				try {
					service.saveAttendanceLog(conn, attendance);
				} catch (BSException e) {
					log("Fail to save (WEB Channel)" + attendance.toString() + " Detail:" + e.toString());
				}
//				service.saveAttendanceLog(conn, attendance);
				// bu.save(conn, attendance);
			} else {
				noSavedCount++;
			}
		}

		if (deleteFromDevice(request)) {
			deleteInfo(machine, conn);
		}
				
		cf.closeConnection(conn);
		
		session.setAttribute(ATTENDANCES, null);

		forward(request, response, "/servlet/timectrl/machine/MachineManager");
	}

	private void deleteInfo(Machine machine, Connection conn) {
		Integer dwMachineNumber = 1;
		MachineService2 machineService = new MachineServiceImpl2();
		_zkemProxy api = machineService.connect(conn, machine);
		api.enableDevice(dwMachineNumber, false);
		api.clearGLog(dwMachineNumber);
		api.enableDevice(dwMachineNumber, true);
		machineService.disconnect(api);
	}

	private boolean deleteFromDevice(HttpServletRequest request) {
		return request.getParameter("DeleteFromDevice") != null;
	}

	private Machine getMachine(Connection conn, HttpServletRequest request) {
		BSBeanUtils bu = new BSBeanUtils();
		Machine out = new Machine();
		Long machineId = Long.parseLong(request.getParameter("Machine"));

		out.setId(machineId);
		bu.search(conn, out);

		return out;
	}
}
