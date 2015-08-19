package cl.buildersoft.web.servlet.admin.country;

import java.sql.Connection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import cl.buildersoft.framework.beans.BSTableConfig;
import cl.buildersoft.framework.type.Semaphore;
import cl.buildersoft.web.servlet.common.HttpServletCRUD;

@WebServlet("/servlet/admin/country/CountryManager")
public class CountryManager extends HttpServletCRUD {
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

}
