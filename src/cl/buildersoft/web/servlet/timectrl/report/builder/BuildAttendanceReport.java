package cl.buildersoft.web.servlet.timectrl.report.builder;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.util.BSConfig;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.business.console.BuildReport;

@WebServlet("/servlet/timectrl/report/builder/BuildAttendanceReport")
public class BuildAttendanceReport extends BSHttpServlet {
	private static final long serialVersionUID = -4629588411889306729L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// BSmySQL mysql = new BSmySQL();
		Connection conn = getConnection(request);

		BuildReport report = new BuildReport();
		report.setConnection(conn);

		String attendanceFile = getAttendanceReportFile(conn);
		String outputFolder = getOutputFolder(conn);
		String startDate = getDate(conn, request, "StartDate");
		String endDate = getDate(conn, request, "EndDate");
		String employee = request.getParameter("Employee");
		String useUsername = request.getParameter("UseUsername");

		String[] params = { "", "", "", attendanceFile, outputFolder, startDate, endDate, employee, useUsername };

		/**
		 * <code>
		String idEmploye = args[7];
		 </code>
		 */
		// report.setFormat("Excel");
		report.doBuild(params);

		request.setAttribute("Message", "Los reportes fueron dejados en la carpeta " + outputFolder);
		forward(request, response, "/WEB-INF/jsp/timectrl/report/message.jsp");
		// request.getRequestDispatcher("/WEB-INF/jsp/timectrl/report/message.jsp").forward(request,
		// response);
	}

	private String getDate(Connection conn, HttpServletRequest request, String fieldName) {
		/**<code>
		String dateString = request.getParameter(fieldName);
		Calendar calendar = BSDateTimeUtil.string2Calendar(dateString, BSDateTimeUtil.getFormatDate(conn));

		String out = BSDateTimeUtil.calendar2String(calendar, "yyyy-MM-dd");

		return dateString;
		</code>
		*/
		
		return (new BuildPlainReport()).getDate(conn, request, fieldName);
	}

	private String getOutputFolder(Connection conn) {
		return new BSConfig().getString(conn, "OUTPUT_REPORT");
	}

	private String getAttendanceReportFile(Connection conn) {
		BSConfig config = new BSConfig();
		return config.getString(conn, "ATTENDANCE_REPORT");
	}
}
