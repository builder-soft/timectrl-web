package cl.buildersoft.web.servlet.timectrl.report.config;

import java.sql.Connection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import cl.buildersoft.framework.type.Semaphore;
import cl.buildersoft.framework.util.crud.BSHttpServletCRUD;
import cl.buildersoft.framework.util.crud.BSTableConfig;

/**
 * Servlet implementation class ReportParamType
 */
@WebServlet("/servlet/timectrl/report/config/ReportParamTypeManager")
public class ReportParamTypeManager extends BSHttpServletCRUD {
	private static final long serialVersionUID = -6922319250040502348L;

	@Override
	protected BSTableConfig getBSTableConfig(HttpServletRequest request) {
		BSTableConfig table = initTable(request, "tReportParamType");
		table.setTitle("Tipos de parámetros para reportes");
		table.removeAction("EDIT");
		return table;
	}

	@Override
	public Semaphore setSemaphore(Connection conn, Object[] values) {
		return null;
	}

	@Override
	protected void configEventLog(BSTableConfig table, Long userId) {
		// TODO Auto-generated method stub

	}

	
}
