package cl.buildersoft.web.servlet.common;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cl.buildersoft.framework.beans.BSTableConfig;
import cl.buildersoft.framework.beans.Domain;
import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.type.Semaphore;
import cl.buildersoft.framework.util.BSHttpServlet;

public abstract class HttpServletCRUD extends BSHttpServlet {
	private static final long serialVersionUID = 713819586332712332L;

	protected abstract BSTableConfig getBSTableConfig(HttpServletRequest request);

	public abstract Semaphore setSemaphore(Connection conn, Object[] values);

	public HttpServletCRUD() {
		super();
	}

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// BSHeadConfig head = getBSHeadConfig();
		BSTableConfig table = getBSTableConfig(request);

		String uri = request.getRequestURI().substring(request.getContextPath().length());

		table.setUri(uri);

		HttpSession session = request.getSession();
		synchronized (session) {
			session.setAttribute("BSTable", table);
			// session.setAttribute("BSHead", head);
		}

		forward(request, response, "/servlet/common/LoadTable");
		// request.getRequestDispatcher("/servlet/common/LoadTable").forward(request,
		// response);
	}

	protected BSTableConfig initTable(HttpServletRequest request, String tableName) {
		return initTable(request, tableName, null);
	}

	protected BSTableConfig initTable(HttpServletRequest request, String tableName, HttpServletCRUD servlet) {
		Domain domain = (Domain) request.getSession().getAttribute("Domain");

		BSTableConfig table = new BSTableConfig(domain.getAlias(), tableName);
		BSmySQL mysql = new BSmySQL();
		Connection conn = getConnection(request);
		table.configFields(conn, mysql);
		mysql.closeConnection(conn);

		if (servlet != null) {
			request.setAttribute("ServletManager", servlet);
		}
		return table;
	}

	protected void hideFields(BSTableConfig table, String... hideFields) {
		for (String fieldName : hideFields) {
			table.getField(fieldName).setVisible(false);
		}
	}

}
