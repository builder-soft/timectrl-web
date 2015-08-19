package cl.buildersoft.web.servlet.common;

import java.io.IOException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cl.buildersoft.framework.beans.BSAction;
import cl.buildersoft.framework.beans.BSTableConfig;
import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.exception.BSDataBaseException;

/**
 * Servlet implementation class SaveRelation
 */
@WebServlet("/servlet/common/SaveRelation")
public class SaveRelation extends HttpServlet {
	private static final long serialVersionUID = -6105983061875822914L;

	public SaveRelation() {
		super();

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("/WEB-INF/jsp/common/no-access.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long id = Long.parseLong(request.getParameter("cId"));
		String[] relations = request.getParameterValues("Relation");

		HttpSession session = request.getSession();
		BSTableConfig table = null;
		synchronized (session) {
			table = (BSTableConfig) session.getAttribute("BSTable");
		}

		BSmySQL mysql = new BSmySQL();
		Connection conn = mysql.getConnection(request);

		BSAction action = table.getAction(request.getParameter("CodeAction"));

		try {
			mysql.setAutoCommit(conn, false);

			removeRelation(conn, mysql, id, table, action);
			setRelation(conn, mysql, id, relations, action);
			mysql.commit(conn);

		} catch (Exception e) {
			mysql.rollback(conn);
			throw new BSDataBaseException("0300", e.getMessage());
		} finally {
			mysql.closeSQL();
			mysql.closeConnection(conn);
		}
		String uri = table.getUri();
		request.getRequestDispatcher(uri).forward(request, response);

	}

	private void setRelation(Connection conn, BSmySQL mysql, Long id, String[] relations, BSAction action) {
		String[] natInfo = action.getNatTable();
		List<Object> prms = new ArrayList<Object>();
		String sql = "INSERT INTO " + natInfo[0] + "." + natInfo[1] + " VALUES(?,?)";

		prms.add(id);

		if (relations != null) {
			for (String relation : relations) {
				prms.add(Long.parseLong(relation));

				mysql.update(conn, sql, prms);
				prms.remove(1);
			}
		}
	}

	private void removeRelation(Connection conn, BSmySQL mysql, Long id, BSTableConfig table, BSAction action) {
		String[] natInfo = action.getNatTable();
		String tableName = natInfo[0] + "." + natInfo[1];

		List<Object> prms = new ArrayList<Object>();
		String sql = "DELETE FROM " + tableName + " WHERE " + table2Field(table.getTableName()) + "=?";

		prms.add(id);

		mysql.update(conn, sql, prms);
	}

	private String table2Field(String tableName) {
		return "c" + tableName.substring(1);
	}
}
