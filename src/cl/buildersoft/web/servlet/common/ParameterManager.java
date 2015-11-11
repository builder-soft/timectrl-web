package cl.buildersoft.web.servlet.common;

import java.sql.Connection;

import javax.servlet.Servlet;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.type.Semaphore;
import cl.buildersoft.framework.util.crud.BSTableConfig;

@WebServlet("/servlet/common/ParameterManager")
public class ParameterManager extends HttpServletCRUD implements Servlet {
	private static final long serialVersionUID = -405265061970863341L;

	public ParameterManager() {
		super();
	}

	@Override
	protected BSTableConfig getBSTableConfig(HttpServletRequest request) {
		BSTableConfig table = new BSTableConfig("bsframework", "tParameter");

		BSmySQL mysql = new BSmySQL();
		Connection conn = mysql.getConnection2("jdbc/bsframework");
		table.configFields(conn, mysql);
		// BSField field;

		table.setTitle("Par�metros del sistema");

		// field = new BSField("cId", "Id");
		// table.addField(field);

		// field = new BSField("cSystem", "Sistema");
		// field.setFK("bscommon", "vSystem", "cName");
		// table.addField(field);

		// field = new BSField("cKey", "Llave");
		// table.addField(field);

		// field = new BSField("cLabel", "Nombre");
		// table.addField(field);

		// field = new BSField("cValue", "Valor");
		// table.addField(field);
		//
		// field = new BSField("cType", "Tipo");
		// field.setFK("bscommon", "vType", "cName");
		// table.addField(field);

		// table.setSortField("cNombre");

		// table.setTitle("Par�metros del sistema");
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
