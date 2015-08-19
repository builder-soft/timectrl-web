package cl.buildersoft.web.servlet.timectrl.report.config;

import java.io.IOException;
import java.sql.Connection;
import java.util.Enumeration;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.exception.BSDataBaseException;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.business.beans.ReportProperty;
import cl.buildersoft.timectrl.business.beans.ReportType;

@WebServlet("/servlet/timectrl/report/config/SavePropertyValue")
public class SavePropertyValue extends BSHttpServlet {
	private static final long serialVersionUID = 8260858993171587707L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = getConnection(request);
		BSmySQL mysql = new BSmySQL();
		BSBeanUtils bu = new BSBeanUtils();
		Long reportId = Long.parseLong(request.getParameter("ReportId"));
		String parameterName = null;
		String parameterValue = null;

		ReportProperty prop = new ReportProperty();

		Enumeration<String> parameterNames = request.getParameterNames();
		try {
//			conn.setAutoCommit(false);
			while (parameterNames.hasMoreElements()) {
				parameterName = parameterNames.nextElement();

				if (parameterName.startsWith("Param#")) {

					parameterValue = request.getParameter(parameterName);

					prop.setId(getId(parameterName));
					prop.setPropertyType(getPropertyType(conn, prop.getId()));
					prop.setReport(reportId);
					prop.setValue(parameterValue);
					bu.save(conn, prop);

				}
			}
//			mysql.commit(conn);
		} catch (Exception e) {
//			mysql.rollback(conn);
			e.printStackTrace();
			throw new BSDataBaseException(e);
		}

		mysql.closeConnection(conn);

		forward(request, response, "/servlet/timectrl/report/config/ReportManager");
	}

	private Long getPropertyType(Connection conn, Long propertyId) {
		BSBeanUtils bu = new BSBeanUtils();

		ReportProperty property = new ReportProperty();
		property.setId(propertyId);

		bu.search(conn, property);

		ReportType reportType = new ReportType();
		reportType.setId(property.getPropertyType());

		bu.search(conn, reportType);

		return reportType.getId();
	}

	private Long getId(String parameterName) {
		return Long.parseLong(parameterName.substring(parameterName.indexOf("#") + 1));
	}
}
