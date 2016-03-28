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
 * Servlet implementation class ReportManager
 */
@WebServlet("/servlet/timectrl/report/config/ReportManager")
public class ReportManager extends BSHttpServletCRUD {
	private static final long serialVersionUID = -6291751723749976986L;

	@Override
	protected BSTableConfig getBSTableConfig(HttpServletRequest request) {
		BSTableConfig table = initTable(request, "tReport");
		table.setTitle("Reportes");
		table.getField("cJavaClass").setShowInTable(false);
		table.getField("cJavaClass").setShowInForm(false);
		table.getField("cJavaClass").setReadonly(true);

		table.setSaveSP("pSaveReport");
		table.setDeleteSP("pDeleteReport");

		BSAction action = new BSAction("PROPERTIES", BSActionType.Record);
		action.setLabel("Propiedades");
		action.setUrl("/servlet/timectrl/report/config/ReportReadProperties");
		table.addAction(action);

		action = new BSAction("PARAMETERS", BSActionType.Record);
		action.setLabel("Parámetros");
		action.setUrl("/servlet/timectrl/report/config/ReportReadParameter");
		table.addAction(action);

		table.removeAction("EDIT");

		table.getField("cKey").setLabel("Llave");
		table.getField("cName").setLabel("Nombre");
		// table.getField("cJasperFile").setLabel("Archivo de reporte");
		table.getField("cType").setLabel("Tipo");

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
