package cl.buildersoft.web.servlet.timectrl.report;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.util.BSDateTimeUtil;
import cl.buildersoft.framework.web.servlet.BSHttpServlet_;

@WebServlet("/servlet/timectrl/report/PlainReport")
public class PlainReport extends BSHttpServlet_ {
	private static final long serialVersionUID = -4353948710355765036L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String dateFormat = BSDateTimeUtil.getFormatDate(request);

		request.setAttribute("DateFormat", dateFormat);

		forward(request, response, "/WEB-INF/jsp/timectrl/report/plain-report.jsp");

	}

}
