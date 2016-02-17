package cl.buildersoft.web.servlet.ajax;

import java.io.IOException;
import java.sql.Connection;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.util.BSDataUtils;

@WebServlet("/servlet/ajax/GetIndicator")
public class GetIndicator extends AbstractAjaxServlet {
	private final static Logger LOG = Logger.getLogger(GetIndicator.class.getName());
	private static final long serialVersionUID = -915879276301350536L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String key = request.getParameter("Key");
		String out = "Key '" + key + "' not found";

		Long startTime = System.currentTimeMillis();

		 

		Connection conn = getConnection(request);
		if ("CurrentVersion".equalsIgnoreCase(key)) {
			out = getCurrentVersion();
		} else if ("LastRead".equalsIgnoreCase(key)) {
			out = getLastRead(conn);
		} else if ("OfflineMch".equalsIgnoreCase(key)) {
			out = getOfflineMch(conn);
		} else if ("EmployeeWORut".equalsIgnoreCase(key)) {
			out = getEmployeeWORut(conn);
		}

		closeConnection(conn);

		Long endTime = System.currentTimeMillis();
		Long time = endTime - startTime;

		if (time < 1000) {
			time = 1000 - time;
		} else {
			time = 0L;
		}

		try {
			 LOG.log(Level.FINE, "Time: {0}", time);
			Thread.sleep(time);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

		setHeaders(response);
		endWrite(writeToBrowser(response, out));
	}

	private String getEmployeeWORut(Connection conn) {
		return getOneData(conn, "select count(*) from temployee where crut is null AND cEnabled=TRUE;", "Todos los empleados con Rut");
	}

	private String getOfflineMch(Connection conn) {
		String a = getOneData(conn, "SELECT COUNT(cid) FROM tMachine WHERE cLastAccess < DATE_ADD(now(), INTERVAL -1 DAY);", "0");
		String b = getOneData(conn, "SELECT COUNT(cid) FROM tMachine;", "0");
		String out = a + "/" + b;

		return out;
	}

	private String getOneData(Connection conn, String sql, String defaultData) {
		BSDataUtils du = new BSDataUtils();
		String out = "";
		String count = du.queryField(conn, sql, null);

		if (count == null || "0".equals(count)) {
			out = defaultData;
		} else {
			out = count;
		}

		return out;
	}

	private String getLastRead(Connection conn) {
		return getOneData(conn, "SELECT MAX(cDate) AS LastRead FROM tAttendanceLog;", "Sin lecturas");
	}

	private String getCurrentVersion() {
		String out = getServletContext().getInitParameter("CurrentVersion");
		return out == null ? "Error en configuración" : out;
	}

}
