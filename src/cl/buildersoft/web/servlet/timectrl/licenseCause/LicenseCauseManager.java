package cl.buildersoft.web.servlet.timectrl.licenseCause;

import java.sql.Connection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import cl.buildersoft.framework.type.Semaphore;
import cl.buildersoft.framework.util.crud.BSTableConfig;
import cl.buildersoft.web.servlet.common.HttpServletCRUD;

/**
 * Servlet implementation class LicenseCause
 */
@WebServlet("/servlet/timectrl/licenseCause/LicenseCauseManager")
public class LicenseCauseManager extends HttpServletCRUD {
	private static final long serialVersionUID = 5784069118987822401L;

	@Override
	protected BSTableConfig getBSTableConfig(HttpServletRequest request) {
		BSTableConfig table = initTable(request, "tLicenseCause");
		table.setTitle("Tipos de licencias y permisos");

		table.getField("cName").setLabel("Descripción");
		return table;

	}

	@Override
	public Semaphore setSemaphore(Connection conn, Object[] values) {
		return null;
	}

}
