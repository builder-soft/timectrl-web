package cl.buildersoft.web.servlet.system.role;

import java.sql.Connection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import cl.buildersoft.framework.beans.Domain;
import cl.buildersoft.framework.type.Semaphore;
import cl.buildersoft.framework.util.crud.BSField;
import cl.buildersoft.framework.util.crud.BSTableConfig;
import cl.buildersoft.web.servlet.common.HttpServletCRUD;

/**
 * Servlet implementation class RolManager
 */
@WebServlet("/servlet/system/role/RolManager")
public class RolManager extends HttpServletCRUD {
	private static final long serialVersionUID = 9083620122736457949L;

	public RolManager() {
		super();

	}

	@Override
	protected BSTableConfig getBSTableConfig(HttpServletRequest request) {
		Domain domain = (Domain) request.getSession().getAttribute("Domain");

		BSTableConfig table = new BSTableConfig(domain.getAlias(), "tRol");
		table.setTitle("Mantenimiento de Roles");

		BSField field = new BSField("cId", "Id");
		table.addField(field);

		field = new BSField("cName", "Nombre");
		table.addField(field);

		return table;
	}

	@Override
	public Semaphore setSemaphore(Connection conn, Object[] values) {
		return null;	
	}

}