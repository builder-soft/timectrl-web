package cl.buildersoft.web.servlet.common.crud;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.util.crud.BSTableConfig;
import cl.buildersoft.web.servlet.common.AbstractServletUtil;

@WebServlet("/servlet/common/crud/DeleteRecords")
public class DeleteRecords extends AbstractServletUtil {
	private static final long serialVersionUID = -2340853411641380529L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		BSTableConfig table = null;
		synchronized (session) {
			table = (BSTableConfig) session.getAttribute("BSTable");
		}
		BSmySQL mysql = new BSmySQL();
		Connection conn = getConnection(request);

//		String idField = table.getPKField(conn).getName();
		String idField = table.getIdField().getName();
		String[] values = request.getParameterValues(idField);

		if (table.getDeleteSP() != null) {
			for (String value : values) {
				Long id = Long.parseLong(value);
				mysql.callSingleSP(conn, table.getDeleteSP(), id);
			}

		} else {
			String sql = getSQL4Search(table, idField);

			for (String value : values) {
				Long id = Long.parseLong(value);
				mysql.update(conn, sql, array2List(id));

			}
		}
		closeConnection(conn);

		request.getRequestDispatcher("/servlet/common/LoadTable").forward(request, response);
	}

	private String getSQL4Search(BSTableConfig table, String idField) {
		// BSField[] fields = table.getFields();
		String sql = "DELETE FROM " + table.getDatabase() + ".";
		sql += table.getTableName();
		sql += " WHERE " + idField + "=?";
		return sql;
	}

}
