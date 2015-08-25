package cl.buildersoft.web.servlet.config.systemparams;

import java.sql.Connection;

import javax.servlet.Servlet;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import cl.buildersoft.framework.type.Semaphore;
import cl.buildersoft.framework.util.crud.BSTableConfig;
import cl.buildersoft.web.servlet.common.HttpServletCRUD;

@WebServlet("/servlet/config/systemparams/ParameterManager")
public class ParameterManager extends HttpServletCRUD implements Servlet {
	private static final long serialVersionUID = 5621476235297476355L;

	public ParameterManager() {
		super();
	}

	@Override
	protected BSTableConfig getBSTableConfig(HttpServletRequest request) {
		BSTableConfig table = initTable(request, "tParameter");

		table.setTitle("Parámetros del sistema");

		table.renameAction("INSERT", "ADD_PARAMS");
		table.renameAction("EDIT", "MOD_PARAMS");
		table.renameAction("DELETE", "DEL_PARAMS");

		return table;
	}

	@Override
	public Semaphore setSemaphore(Connection conn, Object[] values) {
		return null;	
	}

}
