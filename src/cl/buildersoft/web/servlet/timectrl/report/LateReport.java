package cl.buildersoft.web.servlet.timectrl.report;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.util.BSDateTimeUtil;
import cl.buildersoft.framework.web.servlet.BSHttpServlet_;

/**
 * Servlet implementation class LateReport
 */
@WebServlet("/servlet/timectrl/report/LateReport")
public class LateReport extends BSHttpServlet_ {
	private static final long serialVersionUID = 844879514107894973L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String dateFormat = BSDateTimeUtil.getFormatDate(request);

		request.setAttribute("DateFormat", dateFormat);

		forward(request, response, "/WEB-INF/jsp/timectrl/report/late-report.jsp");
	}

}
