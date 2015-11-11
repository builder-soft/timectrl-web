package cl.buildersoft.web.servlet.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.beans.User;
import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.database.BSmySQL;

@WebServlet("/servlet/admin/SearchPassword")
public class SearchPassword extends HttpServlet {
	private static final long serialVersionUID = -4828198556542814787L;

	public SearchPassword() {
		super();
	}

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		Long id;

		String idString = request.getParameter("cId");
		if (idString == null) {
			User user = (User) request.getSession().getAttribute("User");
			id = user.getId();
			request.setAttribute("cId", id);
		} else {
			id = Long.parseLong(idString);
		}
		BSmySQL mysql = new BSmySQL();
		Connection conn = mysql.getConnection2( "jdbc/bsframework");

		BSBeanUtils bu = new BSBeanUtils();
		User user = new User();
		user.setId(id);
		bu.search(conn, user);
		mysql.closeConnection(conn);
		
		request.setAttribute("PASS_IS_NULL", user.getPassword() == null);

		request.getRequestDispatcher("/WEB-INF/jsp/admin/change-password.jsp").forward(request, response);
	}
}
