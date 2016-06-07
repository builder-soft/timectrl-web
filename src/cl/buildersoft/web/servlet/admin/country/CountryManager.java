package cl.buildersoft.web.servlet.admin.country;

import java.sql.Connection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import cl.buildersoft.framework.type.Semaphore;
import cl.buildersoft.framework.util.crud.BSHttpServletCRUD;
import cl.buildersoft.framework.util.crud.BSTableConfig;

@WebServlet("/servlet/admin/country/CountryManager")
public class CountryManager extends BSHttpServletCRUD {
	private static final long serialVersionUID = -2469544835257774997L;

	@Override
	protected BSTableConfig getBSTableConfig(HttpServletRequest request) {
		BSTableConfig table = initTable(request, "tCountry");
		table.setTitle("Paises");

		// table.setSortField("cName");
		return table;
	}

	@Override
	public Semaphore setSemaphore(Connection conn, Object[] values) {
		return null;
	}

	@Override
	protected void configEventLog(BSTableConfig table, Long userId) {
		// TODO Configurar eventos

	}

	@Override
	public void preExecuteAction(BSTableConfig table, String action, Long userId) {
		// TODO Auto-generated method stub

	}

	@Override
	public void postExecuteAction(BSTableConfig table, String action, Long userId) {
		// TODO Auto-generated method stub

	}

}
