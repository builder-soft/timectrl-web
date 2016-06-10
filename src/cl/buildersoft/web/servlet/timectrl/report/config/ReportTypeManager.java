package cl.buildersoft.web.servlet.timectrl.report.config;

import java.sql.Connection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import cl.buildersoft.framework.type.Semaphore;
import cl.buildersoft.framework.util.crud.BSAction;
import cl.buildersoft.framework.util.crud.BSActionType;
import cl.buildersoft.framework.util.crud.BSHttpServletCRUD;
import cl.buildersoft.framework.util.crud.BSTableConfig;

/**
 * Servlet implementation class ReportOutType
 */
@WebServlet("/servlet/timectrl/report/config/ReportTypeManager")
public class ReportTypeManager extends BSHttpServletCRUD {
	private static final long serialVersionUID = 4459912514967689438L;

	@Override
	protected BSTableConfig getBSTableConfig(HttpServletRequest request) {
		BSTableConfig table = initTable(request, "tReportType");
		table.setTitle("Tipos de reportes");
		table.removeAction("INSERT");
		table.removeAction("DELETE");

		BSAction action = new BSAction("PARAMS_DEF", BSActionType.Record);
		action.setLabel("Definicion de parámetros de Salida");
		action.setUrl("/servlet/timectrl/report/config/ReadOutputParamDef");
		// action.setUrl("/servlet/timectrl/report/config/InConfigByReport");
		table.addAction(action);

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
