package cl.buildersoft.web.servlet.system.changepassword;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cl.buildersoft.framework.beans.Domain;
import cl.buildersoft.framework.beans.User;
import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.util.BSHttpServlet;

@WebServlet("/servlet/system/changepassword/SearchPassword")
public class SearchPassword extends BSHttpServlet {
	private static final long serialVersionUID = 7455312993130724891L;

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
		Connection conn = mysql.getConnection2(getServletContext());
		Connection connDomain = getDomainConnection(request);

		BSBeanUtils bu = new BSBeanUtils();
		User user = new User();
		user.setId(id);
		bu.search(conn, user);

		request.setAttribute("PASS_IS_NULL", user.getPassword() == null);

		String page = null;
		if (bootstrap(connDomain)) {
			page = "/WEB-INF/jsp/system/change-password/change-password2.jsp";
		} else {
			page = "/WEB-INF/jsp/system/change-password/change-password.jsp";
		}
		mysql.closeConnection(conn);
		mysql.closeConnection(connDomain);
		forward(request, response, page);
	}

	private Connection getDomainConnection(HttpServletRequest request) {
//		HttpSession session = request.getSession();
//		domain = (Domain) session.getAttribute("Domain");

		return getConnection(request);
	}
}
