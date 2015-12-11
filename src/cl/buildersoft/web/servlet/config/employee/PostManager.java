package cl.buildersoft.web.servlet.config.employee;

import java.sql.Connection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import cl.buildersoft.framework.type.Semaphore;
import cl.buildersoft.framework.util.crud.BSTableConfig;
import cl.buildersoft.web.servlet.common.HttpServletCRUD;

@WebServlet("/servlet/config/employee/PostManager")
public class PostManager extends HttpServletCRUD {
	private static final long serialVersionUID = -6279916596879232684L;

	@Override
	protected BSTableConfig getBSTableConfig(HttpServletRequest request) {
		BSTableConfig table = initTable(request, "tPost");
		table.setTitle("Administración de cargos");

		table.getField("cKey").setLabel("Llave");
		table.getField("cName").setLabel("Descripción");

		return table;
	}

	@Override
	public Semaphore setSemaphore(Connection conn, Object[] values) {
		return null;
	}

}
