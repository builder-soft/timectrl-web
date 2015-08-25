package cl.buildersoft.web.servlet.admin.comuna;

import java.sql.Connection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import cl.buildersoft.framework.type.Semaphore;
import cl.buildersoft.framework.util.crud.BSTableConfig;
import cl.buildersoft.web.servlet.common.HttpServletCRUD;

@WebServlet("/servlet/admin/comuna/ComunaManager")
public class ComunaManager extends HttpServletCRUD {
	private static final long serialVersionUID = -3771211715459399925L;

	@Override
	protected BSTableConfig getBSTableConfig(HttpServletRequest request) {
		BSTableConfig table =  initTable(request, "tComuna");
		table.setTitle("Comunas del país");

		table.setSortField("cName");
		return table;
	}

	@Override
	public Semaphore setSemaphore(Connection conn, Object[] values) {
		return null;		
	}

	 

}
