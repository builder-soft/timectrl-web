package cl.buildersoft.web.servlet.common;

import java.io.IOException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.framework.util.BSUtils;
import cl.buildersoft.framework.util.BSWeb;
import cl.buildersoft.framework.util.crud.BSField;
import cl.buildersoft.framework.util.crud.BSTableConfig;

@WebServlet("/servlet/common/UpdateRecord")
public class UpdateRecord extends BSHttpServlet {
	private static final long serialVersionUID = 729493572423196326L;

	public UpdateRecord() {
		super();
	}

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		BSTableConfig table = null;
		synchronized (session) {
			table = (BSTableConfig) session.getAttribute("BSTable");
		}

		// BSField[] fields = table.getFields();
		BSField idField = table.getIdField();
		BSField[] fieldsWidthoutId = table.deleteId();

		String sql = getSQL(table, fieldsWidthoutId, idField);

		List<Object> params;

		Connection conn = null;
		BSmySQL mysql = new BSmySQL();

		conn = mysql.getConnection(request);
		params = getParams(conn, request, fieldsWidthoutId, idField);

		mysql.update(conn, sql, params);
		mysql.closeConnection(conn);

		request.getRequestDispatcher("/servlet/common/LoadTable").forward(request, response);
	}

	private List<Object> getParams(Connection conn, HttpServletRequest request, BSField[] fieldsWidthoutId, BSField idField) {
		List<Object> out = new ArrayList<Object>();

		for (BSField field : fieldsWidthoutId) {
			if (!field.isReadonly()) {
				out.add(BSWeb.value2Object(conn, request, field, true));
			}
		}
		out.add(BSWeb.value2Object(conn, request, idField, true));

		return out;
	}

	private String getSQL(BSTableConfig table, BSField[] fieldsWidthoutId, BSField idField) {
		String sql = "UPDATE " + table.getDatabase() + "." + table.getTableName();
		sql += " SET " + BSUtils.unSplitField(fieldsWidthoutId, "=?,");
		sql += " WHERE " + idField.getName() + "=?";

		return sql;
	}
}
