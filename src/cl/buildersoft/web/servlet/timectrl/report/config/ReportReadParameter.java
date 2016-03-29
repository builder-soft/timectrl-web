package cl.buildersoft.web.servlet.timectrl.report.config;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.util.BSFactory;
import cl.buildersoft.framework.web.servlet.BSHttpServlet_;
import cl.buildersoft.timectrl.business.beans.Report;
import cl.buildersoft.timectrl.business.beans.ReportParameterBean;
import cl.buildersoft.timectrl.business.beans.ReportParameterType;
import cl.buildersoft.timectrl.business.beans.ReportType;
import cl.buildersoft.timectrl.business.services.ReportService;

/**
 * Servlet implementation class InConfigByReport
 */
@WebServlet("/servlet/timectrl/report/config/ReportReadParameter")
public class ReportReadParameter extends BSHttpServlet_ {
	private static final long serialVersionUID = -436174125408673922L;

	// @ SuppressWarnings("unchecked")
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = getConnection(request);

		Long reportId = Long.parseLong(readParameterOrAttribute(request, "cId"));

		Report report = getReport(conn, reportId);
		ReportType reportType = getReportType(conn, report);

		ReportService reportService = getInstance(reportType);

		List<ReportParameterBean> parameterList = reportService.loadParameter(conn, reportId);
		List<ReportParameterType> parameterTypeList = listReportParamType(conn);
		// treportparamtype

		Integer lastOrder = getLastOrder(parameterList);

		request.setAttribute("ParameterList", parameterList);
		request.setAttribute("Report", report);
		request.setAttribute("ReportType", reportType);
		request.setAttribute("ParameterTypeList", parameterTypeList);
		request.setAttribute("LastOrder", lastOrder);

		forward(request, response, "/WEB-INF/jsp/timectrl/report/config/report-read-parameter.jsp");
	}

	private Integer getLastOrder(List<ReportParameterBean> parameterList) {
		return parameterList.size() + 1;
	}

	@SuppressWarnings("unchecked")
	private List<ReportParameterType> listReportParamType(Connection conn) {
		BSBeanUtils bu = new BSBeanUtils();
		return (List<ReportParameterType>) bu.listAll(conn, new ReportParameterType());
	}

	private Report getReport(Connection conn, Long reportId) {
		BSBeanUtils bu = new BSBeanUtils();
		return new ReportReadProperties().searchReport(conn, bu, reportId);
	}

	public ReportType getReportType(Connection conn, Report report) {
		BSBeanUtils bu = new BSBeanUtils();
		return new ReportReadProperties().searchReportType(conn, bu, report);
	}

	// @ SuppressWarnings("unchecked")
	private ReportService getInstance(ReportType reportType) {
		ReportService instance = null;

		BSFactory factory = new BSFactory();
		instance = (ReportService) factory.getInstance(reportType.getJavaClass());

		return instance;
	}
}
