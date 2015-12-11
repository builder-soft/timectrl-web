package cl.buildersoft.web.servlet.system;

import java.sql.Connection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.type.Semaphore;
import cl.buildersoft.framework.util.crud.BSTableConfig;
import cl.buildersoft.web.servlet.common.HttpServletCRUD;

/**
 * Servlet implementation class DomainAttributeManager
 */
@WebServlet("/servlet/system/DomainAttributeManager")
public class DomainAttributeManager extends HttpServletCRUD {
	private static final long serialVersionUID = -8184294919790127733L;

	@Override
	protected BSTableConfig getBSTableConfig(HttpServletRequest request) {
		BSTableConfig table = new BSTableConfig("bsframework", "tDomainAttribute");

		BSmySQL mysql = new BSmySQL();

		Connection conn = mysql.getConnection2(getServletContext());
		table.configFields(conn, mysql);
		mysql.closeConnection(conn);

		table.setTitle("Atributos de Dominios");
		table.getField("cId").setLabel("Id");
		table.getField("cDomain").setLabel("Dominio");
		table.getField("cKey").setLabel("Llave");
		table.getField("cName").setLabel("Nombre");
		table.getField("cValue").setLabel("Valor");

		return table;
	}

	@Override
	public Semaphore setSemaphore(Connection conn, Object[] values) {
		return null;
	}
}
