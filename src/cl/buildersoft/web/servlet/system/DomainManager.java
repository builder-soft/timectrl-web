package cl.buildersoft.web.servlet.system;

import java.sql.Connection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import cl.buildersoft.framework.beans.BSTableConfig;
import cl.buildersoft.framework.type.Semaphore;
import cl.buildersoft.web.servlet.common.HttpServletCRUD;

@WebServlet("/servlet/system/DomainManager")
public class DomainManager extends HttpServletCRUD {
	private static final long serialVersionUID = -2730980972177816284L;

	@Override
	protected BSTableConfig getBSTableConfig(HttpServletRequest request) {
		
		BSTableConfig table =  new BSTableConfig("bsframework", "tDomain" );
		table.setTitle("Dominios");
		
//		BSTableConfig table = initTable(request, "bsframework.tDomain");

		return table;
	}

	@Override
	public Semaphore setSemaphore(Connection conn, Object[] values) {
		return null;
	}

}
