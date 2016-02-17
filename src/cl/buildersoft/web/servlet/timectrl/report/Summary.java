package cl.buildersoft.web.servlet.timectrl.report;

import java.sql.Connection;
import java.util.Calendar;

import javax.servlet.Servlet;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.report.BSAbstractReport;
import cl.buildersoft.framework.report.BSReport;
import cl.buildersoft.framework.util.BSConnectionFactory;
import cl.buildersoft.framework.util.BSDateTimeUtil;
import cl.buildersoft.timectrl.business.beans.BSParamReport;
import cl.buildersoft.timectrl.type.BSParamReportType;

@WebServlet("/servlet/timectrl/report/Summary")
public class Summary extends BSAbstractReport implements Servlet {
	private static final long serialVersionUID = -4154378248979494002L;

	/**
	 * <code>
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	}
	</code>
	 */

	public BSReport getReportSpec(HttpServletRequest request) {
		BSConnectionFactory cf = new BSConnectionFactory();
		Connection conn = cf.getConnection(request);

		BSReport report = new BSReport();

		report.setTitle("Resumen de información.");
		report.setSpName("pSummary");

		BSParamReport param = new BSParamReport(BSParamReportType.DATE, "cStartDate");
		param.setLabel("Fecha inicio");
		param.setRequired(Boolean.TRUE);
		String value = getStartDate(request);
		param.setValue(value);
		report.addParamReport(param);

		param = new BSParamReport(BSParamReportType.DATE, "cEndDate");
		param.setLabel("Fecha final");
		param.setRequired(Boolean.TRUE);
		getEndDate(request, param);
		report.addParamReport(param);

		param = new BSParamReport(BSParamReportType.SELECT, "cEmployee");
		param.addOption("", "Todos");
		param.addOption(conn, "SELECT cKey, cName AS cFullName FROM tEmployee WHERE cEnabled=TRUE", null);
		param.setLabel("Empleado");
		report.addParamReport(param);

		param = new BSParamReport(BSParamReportType.SELECT, "cTurn");
		// param.addOption("", "Todos");
		param.addOption("Noche", "Noche");
		param.addOption("AM", "AM");
		param.addOption("PM", "PM");
		param.setLabel("Turno");
		report.addParamReport(param);

		cf.closeConnection(conn);

		return report;

	}

	private void getEndDate(HttpServletRequest request, BSParamReport param) {
		String value;
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.MONTH, -1);
		calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));

		value = getDateAsString(request, calendar);
		param.setValue(value);
	}

	private String getStartDate(HttpServletRequest request) {
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.MONTH, -1);
		calendar.set(Calendar.DAY_OF_MONTH, 1);
		String value = getDateAsString(request, calendar);
		return value;
	}

	private String getDateAsString(HttpServletRequest request, Calendar calendar) {
		String format = BSDateTimeUtil.getFormatDate(request);
		return BSDateTimeUtil.calendar2String(calendar, format);
	}
}
