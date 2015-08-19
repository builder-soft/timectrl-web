package cl.buildersoft.web.servlet.timectrl.report.execute;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.business.beans.Report;

/**
 * Servlet implementation class ExecutionReport
 */
@WebServlet("/servlet/timectrl/report/execute/ExecutionReport")
public class ExecutionReport extends BSHttpServlet {
	private static final long serialVersionUID = 5522309239924345512L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		List<Report> reports = getReportList(getConnection(request));
		
		request.setAttribute("ReportList", reports);
		
		forward(request, response, "/WEB-INF/jsp/timectrl/report/execute/report-list.jsp");
	}

	@SuppressWarnings("unchecked")
	private List<Report> getReportList(Connection conn) {
		List<Report> out = null;

		BSBeanUtils bu = new BSBeanUtils();
		out = (List<Report>) bu.listAll(conn, new Report());

		return out;
	}

}
