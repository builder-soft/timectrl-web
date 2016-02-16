package cl.buildersoft.web.servlet.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.util.BSConnectionFactory;

@WebServlet("/servlet/admin/PersonFK")
public class PersonFK extends HttpServlet {
	private static final long serialVersionUID = -614956026680417724L;

	public PersonFK() {
		super();
	}

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		BSmySQL mysql = new BSmySQL();
		BSConnectionFactory cf = new BSConnectionFactory();
		Connection conn = cf.getConnection(request);

		List<Object> prms = new ArrayList<Object>();
		prms.add("hola po");

		ResultSet rss = mysql.callSingleSP(conn, "getAllFK", prms);
		Map<Long, Map<String, Object>> data = mysql.resultSet2Map(rss);

		cf.closeConnection(conn);
		request.setAttribute("Data", data);

		request.getRequestDispatcher("/WEB-INF/jsp/admin/person-fk.jsp").forward(request, response);

	}
}
