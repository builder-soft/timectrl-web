package cl.buildersoft.web.servlet.ajax;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.util.BSDataUtils;
import cl.buildersoft.framework.util.BSUtils;

@WebServlet("/servlet/ajax/GetIndicator")
public class GetIndicator extends AbstractAjaxServlet {
	private static final int WAIT_CLIENT = 300;
	private final static Logger LOG = Logger.getLogger(GetIndicator.class.getName());
	private static final long serialVersionUID = -915879276301350536L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String key = request.getParameter("Key");
		String out = "Key '" + key + "' not found";

		Long startTime = System.currentTimeMillis();

		Connection conn = getConnection(request);
		try {
			if ("CurrentVersion".equalsIgnoreCase(key)) {
				out = getCurrentVersion();
			} else if ("LastRead".equalsIgnoreCase(key)) {
				out = getLastRead(conn);
			} else if ("OfflineMch".equalsIgnoreCase(key)) {
				out = getOfflineMch(conn);
			} else if ("EmployeeWORut".equalsIgnoreCase(key)) {
				out = getEmployeeWORut(conn);
			} else if ("CurrentMarks".equalsIgnoreCase(key)) {
				out = getCurrentMarks(conn);
			} else if ("LaterCount".equalsIgnoreCase(key)) {
				out = getLaterCount(conn);
			}
		} finally {
			closeConnection(conn);
		}

		Long endTime = System.currentTimeMillis();
		Long time = endTime - startTime;

		if (time < WAIT_CLIENT) {
			time = WAIT_CLIENT - time;
		} else {
			time = 0L;
		}

		try {
			LOG.log(Level.FINE, "Time: {0}", time);
			Thread.sleep(time);
		} catch (InterruptedException e) {
			LOG.log(Level.SEVERE, "Error: {0}", e);
		}

		setHeaders(response);
		endWrite(writeToBrowser(response, out));
	}

	private String getLaterCount(Connection conn) {
		BSmySQL mysql = new BSmySQL();
		String spName = "pGetLaterCount";
		ResultSet rs = mysql.callSingleSP(conn, spName, Calendar.getInstance());
		String[] defaultData = null;

		String[] out = new String[2];
		out=	fixTwoData(rs, out, defaultData);

		return dataToString(out);
	}

	private String getCurrentMarks(Connection conn) {
		String out = null;
		Calendar c = Calendar.getInstance();
		c.set(Calendar.SECOND, 0);
		c.set(Calendar.MINUTE, 0);
		c.set(Calendar.HOUR, 0);

		// c.set(2016, 1, 18, 0, 0, 0);

		String sql = "SELECT COUNT(cId) AS cValue FROM tAttendanceLog WHERE cDate BETWEEN ? AND NOW() AND cMarkType=1 GROUP BY cMarkType UNION SELECT COUNT(cId) AS cValue FROM tEmployee;";
		String[] data = getTwoData(conn, sql, null, BSUtils.array2List(c));

		out = dataToString(data);

		return out;
	}

	private String dataToString(String[] data) {
		String out;
		if (data == null) {
			out = "Sin registros hoy";
		} else {
			Integer a = Integer.parseInt(data[0]);
			Integer b = Integer.parseInt(data[1]);
			out = ((a * 100) / b) + "%";
		}
		return out;
	}

	private String getEmployeeWORut(Connection conn) {
		return getOneData(conn, "select count(*) from temployee where crut is null AND cEnabled=TRUE;",
				"Todos los empleados con Rut");
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

	private String[] getTwoData(Connection conn, String sql, String[] defaultData, List<Object> params) {
		BSDataUtils du = new BSDataUtils();
		String[] out = new String[2];

		ResultSet rs = du.queryResultSet(conn, sql, params);

		out = fixTwoData(rs, out, defaultData);

		return out;
	}

	private String[] fixTwoData(ResultSet rs, String[] out, String[] defaultData) {
		try {
			if (rs.next()) {
				out[0] = rs.getString(1);
				if (rs.next()) {
					out[1] = rs.getString(1);
				}
				if (out[0] == null || out[1] == null) {
					out = defaultData;
				}
			} else {
				out = defaultData;
			}
		} catch (SQLException e) {
			LOG.log(Level.SEVERE, "Error SQL: {0}", e);
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
