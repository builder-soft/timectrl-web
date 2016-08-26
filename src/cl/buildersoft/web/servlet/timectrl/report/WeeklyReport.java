package cl.buildersoft.web.servlet.timectrl.report;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.web.servlet.BSHttpServlet_;
import cl.buildersoft.timectrl.business.beans.IdRut;
import cl.buildersoft.timectrl.business.console.BuildReport;

@WebServlet("/servlet/timectrl/report/WeeklyReport")
public class WeeklyReport extends BSHttpServlet_ {  
	private static final long serialVersionUID = 8430832862128615541L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//		BSmySQL mysql = new BSmySQL();
		BuildReport buildReport = new BuildReport();
		Connection conn = getConnection(request);
		List<IdRut> idRutList = null;
//		String dateFormat = BSDateTimeUtil.getFormatDate(request);

		try {
			idRutList = buildReport.getEmployeeList(conn, "0");
		} catch (Exception e) {
			throw new ServletException(e.getMessage());
		}

		request.setAttribute("IdRutList", idRutList);
//		request.setAttribute("DateFormat", dateFormat);

		forward(request, response, "/WEB-INF/jsp/timectrl/report/weekly-report.jsp");

	}

}
