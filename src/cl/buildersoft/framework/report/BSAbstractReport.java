package cl.buildersoft.framework.report;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.exception.BSDataBaseException;
import cl.buildersoft.framework.util.BSConnectionFactory;
import cl.buildersoft.framework.util.BSDateTimeUtil;
import cl.buildersoft.framework.web.servlet.BSHttpServlet_;
import cl.buildersoft.timectrl.business.beans.BSParamReport;
import cl.buildersoft.timectrl.type.BSParamReportType;

// @WebServlet("/servlet/Report")
public abstract class BSAbstractReport extends BSHttpServlet_ {
	private static final long serialVersionUID = 5237687092259523326L;

	protected abstract BSReport getReportSpec(HttpServletRequest request);

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = getAction(request);
		String url = "/WEB-INF/jsp/framework/report/main-report.jsp";

		if ("".equals(action)) {
			BSReport report = getReportSpec(request);

			String uri = request.getRequestURI().substring(request.getContextPath().length());
			report.setUri(uri);

			HttpSession session = request.getSession(false);
			synchronized (session) {
				session.setAttribute("BSReport", report);
			}

		} else {
			HttpSession session = request.getSession(false);
			BSReport report = null;
			synchronized (session) {
				report = (BSReport) session.getAttribute("BSReport");
			}
			String spName = report.getSpName();

			BSmySQL mysql = new BSmySQL();
			BSConnectionFactory cf = new BSConnectionFactory();
			Connection conn = cf.getConnection(request);

			List<Object> params = getParameters(request, report);
			ResultSet rs = mysql.callSingleSP(conn, spName, params);

			String[] heads = getHeads(rs);
			List<String[]> data = resultSetToList(rs);

			request.setAttribute("Heads", heads);
			request.setAttribute("Data", data);

			if ("download".equals(action)) {
				url = "/servlet/framework/report/DownloadReport";
			}
			cf.closeConnection(conn);
		}

		String dateFormat = BSDateTimeUtil.getFormatDate(request);
		request.setAttribute("DateFormat", dateFormat);

		forward(request, response, url);
	}

	private String getAction(HttpServletRequest request) {
		String out = "";
		Boolean isRun = request.getParameter("run") != null;
		Boolean isDownload = request.getParameter("download") != null;

		if (isRun) {
			out = "run";
		} else {
			if (isDownload) {
				out = "download";
			}
		}

		return out;
	}

	public List<String[]> resultSetToList(ResultSet rs) {
		List<String[]> out = new ArrayList<String[]>();

		ResultSetMetaData md;
		try {
			md = rs.getMetaData();

			Integer columns = md.getColumnCount();
			String[] row = null;
			while (rs.next()) {
				row = new String[columns];
				for (int i = 0; i < columns; i++) {
					row[i] = rs.getString(i + 1);
				}
				out.add(row);
			}
		} catch (SQLException e) {
			throw new BSDataBaseException(e);
		}
		return out;
	}

	private String[] getHeads(ResultSet rs) {
		String[] out = null;

		try {
			ResultSetMetaData md = rs.getMetaData();
			List<String> fields = new ArrayList<String>();
			Integer index = null;
			for (index = 1; index <= md.getColumnCount(); index++) {
				fields.add(md.getColumnLabel(index));
			}

			out = new String[fields.size()];
			index = 0;
			for (String field : fields) {
				out[index++] = field;
			}
		} catch (SQLException e) {
			throw new BSDataBaseException(e);
		}

		return out;
	}

	private List<Object> getParameters(HttpServletRequest request, BSReport report) {
		List<BSParamReport> params = null;// report.listParamReport();
		List<Object> out = new ArrayList<Object>();
		String name = null;
		String value = null;
		for (BSParamReport param : params) {
			name = param.getName();
			value = request.getParameter(name);
			out.add(convertParam(request, param, value));
			param.setValue(value);
		}

		return out;
	}

	private Object convertParam(HttpServletRequest request, BSParamReport param, String value) {
		BSParamReportType type = param.getParamType();
		Object out = null;
		if (type.equals(BSParamReportType.DATE)) {
			out = value.trim().length() == 0 ? null : BSDateTimeUtil.string2Calendar(request, value);
		} else if (type.equals(BSParamReportType.TEXT) || type.equals(BSParamReportType.SELECT)) {
			out = (String) value;
		}
		return out;
	}

}
