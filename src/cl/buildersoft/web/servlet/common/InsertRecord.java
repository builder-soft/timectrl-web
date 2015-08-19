package cl.buildersoft.web.servlet.common;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cl.buildersoft.framework.beans.BSField;
import cl.buildersoft.framework.beans.BSTableConfig;
import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.exception.BSDataBaseException;
import cl.buildersoft.framework.util.BSWeb;

@WebServlet("/servlet/common/InsertRecord")
public class InsertRecord extends AbstractServletUtil {
	private static final long serialVersionUID = 947236230190327847L;

	/**
	 * @Override protected void doGet(HttpServletRequest request,
	 *           HttpServletResponse response) throws ServletException,
	 *           IOException {
	 *           request.getRequestDispatcher("/WEB-INF/jsp/common/no-access.jsp"
	 *           ).forward(request, response); }
	 */
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		BSTableConfig table = null;

		synchronized (session) {
			table = (BSTableConfig) session.getAttribute("BSTable");
		}

		String saveSP = table.getSaveSP();

		BSmySQL mysql = new BSmySQL();
		Connection conn = getConnection(request);
		BSField[] fields = table.deleteId();
		if (saveSP == null) {
			String sql = getSQL(table, fields, request);
			List<Object> params = getValues4Insert(conn, request, fields);
			Long id = mysql.insert(conn, sql, params);
			request.setAttribute("cId", id);
		} else {
			fields = table.getFields();
			List<Object> params = getValues4Insert(conn, request, fields);
			ResultSet rs = mysql.callSingleSP(conn, saveSP, params);
			// ResultSet rs = mysql.callSingleSP(conn, getSQLsp(saveSP, table,
			// fields), params);
			if (rs != null) {
				try {
					if (rs.next()) {
						request.setAttribute("cId", rs.getLong(1));
					}
				} catch (SQLException e) {
					throw new BSDataBaseException(e);
				}
				mysql.closeSQL(rs);
			}
		}
		mysql.closeConnection(conn);

		request.getRequestDispatcher("/servlet/common/LoadTable").forward(request, response);
	}

	private String getSQL(BSTableConfig table, BSField[] fields, HttpServletRequest request) {
		String sql = "INSERT INTO " + table.getDatabase() + "." + table.getTableName();
		sql += "(" + unSplit(fields, ",") + ") ";
		sql += " VALUES (" + getCommas(fields) + ")";

		return sql;
	}

	/**
	 * <code>
	private String getSQLsp(String spName, BSTableConfig table) {
		return getSQLsp(spName, table, table.getFields());
	}

	private String getSQLsp(String spName, BSTableConfig table, BSField[] fields) {
		String sql = "call " + table.getDatabase() + "." + spName;
		sql += "(" + getCommas(fields) + ") ";
		return sql;

	}
</code>
	 */
	private List<Object> getValues4Insert(Connection conn, HttpServletRequest request, BSField[] fields) {
		List<Object> out = new ArrayList<Object>();
		Object value = null;

		for (BSField field : fields) {
			if (!field.isReadonly()) {
				value = BSWeb.value2Object(conn, request, field, true);
				out.add(value);
			}
		}
		return out;
	}

	/**
	 * <code>
	private List<Object> getValues4sp(Connection conn,
			HttpServletRequest request, BSField[] fields) {

		List<Object> out = new ArrayList<Object>();
		Object value = null;

		for (BSField field : fields) {
			value = BSWeb.value2Object(conn, request, field, true);
			out.add(value);
		}
		return out;
	}
	</code>
	 */
}
