package cl.buildersoft.web.servlet.timectrl.report.builder;

import java.io.IOException;
import java.sql.Connection;
import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.export.ooxml.JRXlsxExporter;

import cl.buildersoft.framework.util.BSConfig;
import cl.buildersoft.framework.util.BSDateTimeUtil;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.business.beans.IdRut;
import cl.buildersoft.timectrl.business.console.BuildReport;
import cl.buildersoft.timectrl.business.console.BuildReport2;

@WebServlet("/servlet/timectrl/report/builder/BuildWeeklyReport")
public class BuildWeeklyReport extends BSHttpServlet {
	private static final long serialVersionUID = 8107800614812374194L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = getConnection(request);

		BuildReport2 report = new BuildReport2();
		report.setConnection(conn);

		String weeklyFile = getWeeklyReportFile(conn);
		String outputFolder = getOutputFolder(conn);
		String month = request.getParameter("Month");
		String year = request.getParameter("Year");
		String employee = request.getParameter("Employee");
		String useUsername = request.getParameter("UseUsername");

		BuildReport buildReport = new BuildReport();
		List<IdRut> employeeList = buildReport.getEmployeeList(conn, employee);
		for (IdRut idRut : employeeList) {
			String[] params = { idRut.getId().toString(), month, year };

			String folder = buildReport.validateFolder(outputFolder, idRut, Boolean.parseBoolean(useUsername));
			String fileName =   (Boolean.parseBoolean(useUsername) ? "Report-"
							+ BSDateTimeUtil.calendar2String(Calendar.getInstance(), "yyyy-MM-dd") : idRut.getRut() + "."
							+ idRut.getId()) + ".pdf";

			report.setFileName(folder + fileName);

			// String[] params = { "", "", "", weeklyFile, outputFolder, month,
			// year, employee, useUsername };

			  report.doBuild("WEEKLY", params);
			// report.doBuild(params);
		}

		request.setAttribute("Message", "Los reportes fueron dejados en la carpeta " + outputFolder);
		forward(request, response, "/WEB-INF/jsp/timectrl/report/message.jsp");
		// request.getRequestDispatcher("/WEB-INF/jsp/timectrl/report/message.jsp").forward(request,
		// response);
	}

	private String getOutputFolder(Connection conn) {
		return new BSConfig().getString(conn, "OUTPUT_REPORT");
	}

	private String getWeeklyReportFile(Connection conn) {
		BSConfig config = new BSConfig();
		return config.getString(conn, "WEEKLY_REPORT");
	}
}
