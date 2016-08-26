package cl.buildersoft.web.servlet.timectrl.report.config;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.web.servlet.BSHttpServlet_;
import cl.buildersoft.timectrl.business.beans.ReportType;

/**
 * Servlet implementation class ReadOutputParamDef
 */
@WebServlet("/servlet/timectrl/report/config/ReadOutputParamDef")
public class ReadOutputParamDef extends BSHttpServlet_ {
	private static final long serialVersionUID = -3818087279889911563L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		/**
		 * <code>
		   - Leer tabla tReportOutParam en base al tipo de reporte que llega por parámetro. 
		   - Grabar en la tabla tReportOutValue -
		</code>
		 */
		Long id = Long.parseLong(request.getParameter("cId"));
		BSBeanUtils bu = new BSBeanUtils();
		Connection conn = getConnection(request);

//		List<ReportOutParam> reportOutParamList = (List<ReportOutParam>) bu.list(conn, new ReportOutParam(), "cType=?", id);
		ReportType reportType = getReportType(conn, bu, id);

		request.setAttribute("ReportOutParamList", null);
		request.setAttribute("ReportType", reportType);

		forward(request, response, "/WEB-INF/jsp/timectrl/report/execute/read-output-param-def.jsp");
		// showParameters(request);

	}

	private ReportType getReportType(Connection conn, BSBeanUtils bu, Long id) {
		ReportType out = new ReportType();

		out.setId(id);
		bu.search(conn, out);

		return out;
	}
}
