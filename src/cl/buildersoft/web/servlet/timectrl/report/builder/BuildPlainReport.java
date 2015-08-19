package cl.buildersoft.web.servlet.timectrl.report.builder;

import java.io.IOException;
import java.sql.Connection;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.util.BSDateTimeUtil;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.business.console.BuildReport2;

@WebServlet("/servlet/timectrl/report/builder/BuildPlainReport")
public class BuildPlainReport extends BSHttpServlet {
	private static final long serialVersionUID = 5471893060924121724L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = getConnection(request);

		String[] params = { getDate(conn, request, "StartDate"), getDate(conn, request, "EndDate") };

		BuildReport2 br = new BuildReport2();

		br.setConnection(conn);
		br.doBuild(5L, params);
		String fileName = br.getFileName(conn);

		request.setAttribute("Message", "El reporte fué generado como " + fileName);
		request.getRequestDispatcher("/WEB-INF/jsp/timectrl/report/message.jsp").forward(request, response);
	}

	public String getDate(Connection conn, HttpServletRequest request, String fieldName) {
		String dateString = request.getParameter(fieldName);
		Calendar calendar = BSDateTimeUtil.string2Calendar(dateString, BSDateTimeUtil.getFormatDate(conn));

		String out = BSDateTimeUtil.calendar2String(calendar, "yyyy-MM-dd");

		return out;
	}
	/**
	 * <code>
	private String getFormat(HttpServletRequest request) {
		String extention = ".pdf";
		if (this.format.equalsIgnoreCase("pdf")) {
			exporter = new JRPdfExporter();
		} else if (this.format.equalsIgnoreCase("Excel")) {
			exporter = new JRXlsExporter();
			extention = ".xls";
		}
		return "xls";
	}


	private Map<String, Object> getParams(String startDate, String endDate) {
		Map<String, Object> out = new HashMap<String, Object>();

		// Integer idEmployeInteger = Integer.parseInt(employee);
		BSDateTimeUtil dtu = new BSDateTimeUtil();

		Date startDateDate = dtu.calendar2Date(dtu.string2Calendar(startDate, "yyyy-MM-dd"));
		Date endDateDate = dtu.calendar2Date(dtu.string2Calendar(endDate, "yyyy-MM-dd"));

		out.put("StartDate", startDateDate);
		out.put("EndDate", endDateDate);
		// out.put("UserId", 0);

		return out;

	}
	
	private String getOutputFolder(Connection conn) {
		return new BSConfig().getString(conn, "OUTPUT_REPORT");
	}

	private String getPlainReportFile(Connection conn) {
		BSConfig config = new BSConfig();
		return config.getString(conn, "PLAIN_REPORT");
	}
	
</code>
	 */

}
