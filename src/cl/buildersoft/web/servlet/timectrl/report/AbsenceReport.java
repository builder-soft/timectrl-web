package cl.buildersoft.web.servlet.timectrl.report;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.util.BSHttpServlet;

/**
 * Servlet implementation class AbsenceReport
 */
@WebServlet("/servlet/timectrl/report/AbsenceReport")
public class AbsenceReport extends BSHttpServlet {
	private static final long serialVersionUID = -1660248937245379215L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//		String dateFormat = BSDateTimeUtil.getFormatDate(request);
//
//		request.setAttribute("DateFormat", dateFormat);

		forward(request, response, "/WEB-INF/jsp/timectrl/report/absence-report.jsp");

	}

}
