package cl.buildersoft.web.servlet.timectrl.report.builder;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.business.console.BuildReport2;

@WebServlet("/servlet/timectrl/report/builder/BuildLateReport")
public class BuildLateReport extends BSHttpServlet {
	private static final long serialVersionUID = -8834791727841994424L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = getConnection(request);

		String[] params = { getDate(conn, request, "StartDate"), getDate(conn, request, "EndDate") };

		BuildReport2 br = new BuildReport2();

		br.setConnection(conn);
		br.doBuild(8L, params);
		String fileName = br.getFileName(conn);

		request.setAttribute("Message", "El reporte fué generado como " + fileName);
		forward(request, response, "/WEB-INF/jsp/timectrl/report/message.jsp");
		// request.getRequestDispatcher("/WEB-INF/jsp/timectrl/report/message.jsp").forward(request,
		// response);

		/**
		 * <code>
		Connection conn = getConnection(request);

		String plainFile = getPlainReportFile(conn);
		String outputFolder = getOutputFolder(conn);
		String outputFileName = getOutputFileName(conn);
		String format = getFormat(outputFileName);
		String startDate = getDate(conn, request, "StartDate");
		String endDate = getDate(conn, request, "EndDate");

		// String employee = request.getParameter("Employee");

		Map<String, Object> params = getParams(startDate, endDate);

		File file = new File(plainFile);
		String fileName = null;
		try {
			JasperReport reporte = (JasperReport) JRLoader.loadObject(file);
			JasperPrint jasperPrint = JasperFillManager.fillReport(reporte, params, conn);

			JRExporter exporter = null;

			format = left(format, 3);
			if (format.equalsIgnoreCase("pdf")) {
				exporter = new JRPdfExporter();
			} else if (format.equalsIgnoreCase("xls")) {
				exporter = new JRXlsExporter();
			}

			// fileName = fu.fixPath(outputFolder) + "reporte-"+
			// idRut.getId() + ".pdf";

			BSFileUtil fu = new BSFileUtil();
			fileName = fu.fixPath(outputFolder) + outputFileName;

			exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
			exporter.setParameter(JRExporterParameter.OUTPUT_FILE, new File(fileName));

			exporter.exportReport();
		} catch (JRException e) {
			throw new ServletException(e);
		}

		new BSmySQL().closeConnection(conn);
		
		request.setAttribute("Message", "El reporte fué generado como " + fileName);
		request.getRequestDispatcher("/WEB-INF/jsp/timectrl/report/message.jsp").forward(request, response);
		</code>
		 */
	}

	private String getDate(Connection conn, HttpServletRequest request, String fieldName) {
		/**
		 * <code>
		String dateString = request.getParameter(fieldName);
		Calendar calendar = BSDateTimeUtil.string2Calendar(dateString, BSDateTimeUtil.getFormatDate(conn));

		String out = BSDateTimeUtil.calendar2String(calendar, "yyyy-MM-dd");

		return dateString;
		</code>
		 */
		return (new BuildPlainReport()).getDate(conn, request, fieldName);
	}
	/**
	 * <code>
	private String left(String s, int i) {
		return s.substring(0, i);
	}
	private String getOutputFileName(Connection conn) {
		return new BSConfig().getString(conn, "OUTPUT_LATE_NAME");
	}

	private String getFormat(String outputFileName) {
		String out = outputFileName.substring(outputFileName.lastIndexOf(".") + 1);
		 
		String extention = ".pdf";
		if (this.format.equalsIgnoreCase("pdf")) {
			exporter = new JRPdfExporter();
		} else if (this.format.equalsIgnoreCase("Excel")) {
			exporter = new JRXlsExporter();
			extention = ".xls";
		}


		return out;
	}

	private Map<String, Object> getParams(String startDate, String endDate) {
		Map<String, Object> out = new HashMap<String, Object>();

		// Integer idEmployeInteger = Integer.parseInt(employee);
		BSDateTimeUtil dtu = new BSDateTimeUtil();

		Date startDateDate = dtu.calendar2Date(dtu.string2Calendar(startDate, "yyyy-MM-dd"));
		Date endDateDate = dtu.calendar2Date(dtu.string2Calendar(endDate, "yyyy-MM-dd"));

		out.put("StartDate", startDateDate);
		out.put("EndDate", endDateDate);
		out.put("UserId", 0);

		return out;

	}



	private String getOutputFolder(Connection conn) {
		return new BSConfig().getString(conn, "OUTPUT_REPORT");
	}

	private String getPlainReportFile(Connection conn) {
		BSConfig config = new BSConfig();
		return config.getString(conn, "LATE_REPORT");
	}

</code>
	 */
}
