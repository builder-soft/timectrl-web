package cl.buildersoft.web.servlet.timectrl.report.config;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.business.beans.ReportInputParameter;

/**
 * Servlet implementation class DeleteParameterValue
 */
@WebServlet("/servlet/timectrl/report/config/DeleteParameterValue")
public class DeleteParameterValue extends BSHttpServlet {
	private static final long serialVersionUID = -4885806582101119958L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long id = Long.parseLong(request.getParameter("ParamId"));
		Long reportId = Long.parseLong(request.getParameter("Report"));

		BSBeanUtils bu = new BSBeanUtils();
		ReportInputParameter rip = new ReportInputParameter();
		rip.setId(id);

		bu.delete(getConnection(request), rip);

		request.setAttribute("cId", reportId.toString());
		forward(request, response, "/servlet/timectrl/report/config/ReportReadParameter");
	}

}
