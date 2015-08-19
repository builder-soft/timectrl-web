package cl.buildersoft.web.servlet.timectrl.report.builder;

import java.io.IOException;
import java.sql.Connection;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.util.BSConfig;
import cl.buildersoft.framework.util.BSDateTimeUtil;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.business.console.BuildReport2;

/**
 * Servlet implementation class BuildAbsenceReport
 */
@WebServlet("/servlet/timectrl/report/builder/BuildAbsenceReport")
public class BuildAbsenceReport extends BSHttpServlet {
	private static final long serialVersionUID = 1036808335585111192L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = getConnection(request);

		String[] params = { getDate(conn, request, "AbsenceDate") };

		BuildReport2 br = new BuildReport2();

		br.setConnection(conn);
		br.doBuild(6L, params);
		String fileName = br.getFileName(conn);

		request.setAttribute("Message", "El reporte fué generado como " + fileName);
		forward(request, response, "/WEB-INF/jsp/timectrl/report/message.jsp");

	}

	private String getDate(Connection conn, HttpServletRequest request, String fieldName) {
		return (new BuildPlainReport()).getDate(conn, request, fieldName);
	}

}
