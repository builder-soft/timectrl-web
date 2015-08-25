package cl.buildersoft.web.servlet.timectrl.group;

import java.sql.Connection;

import javax.servlet.Servlet;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import cl.buildersoft.framework.type.Semaphore;
import cl.buildersoft.framework.util.crud.BSTableConfig;
import cl.buildersoft.web.servlet.common.HttpServletCRUD;

/**
 * Servlet implementation class GroupManager
 */
@WebServlet("/servlet/timectrl/group/GroupManager")
public class GroupManager extends HttpServletCRUD implements Servlet {

	private static final long serialVersionUID = 3184260270714292723L;

	@Override
	protected BSTableConfig getBSTableConfig(HttpServletRequest request) {
		BSTableConfig table = initTable(request, "tGroup");
		table.setTitle("Grupos de Relojes y Empleados");
		return table;
	}

	@Override
	public Semaphore setSemaphore(Connection conn, Object[] values) {
		return null;
	}

}