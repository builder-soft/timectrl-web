package cl.buildersoft.web.servlet.timectrl.fiscalDate;

import java.sql.Connection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import cl.buildersoft.framework.Semaphore;
import cl.buildersoft.framework.util.crud.BSTableConfig;
import cl.buildersoft.framework.web.servlet.HttpServletCRUD;

@WebServlet("/servlet/timectrl/fiscalDate/FiscalDateManager")
public class FiscalDateManager extends HttpServletCRUD {
	private static final long serialVersionUID = 239341883519379947L;

	@Override
	protected BSTableConfig getBSTableConfig(HttpServletRequest request) {
		BSTableConfig table = initTable(request, "tFiscalDate");
		table.setTitle("Tabla de Feriados");

		table.getField("cReason").setLabel("Motivo");
		table.getField("cDate").setLabel("Fecha");

		table.setSortField("cDate");
		return table;
	}

	@Override
	public Semaphore setSemaphore(Connection conn, Object[] values) {
		return null;
	}

	@Override
	public String getBusinessClass() {
		return this.getClass().getName();
	}

	@Override
	public void writeEventLog(Connection conn, String action, HttpServletRequest request, BSTableConfig table) {
		// TODO Auto-generated method stub

	}
}
