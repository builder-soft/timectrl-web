package cl.buildersoft.web.servlet.login;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cl.buildersoft.framework.beans.Menu;
import cl.buildersoft.framework.beans.Rol;
import cl.buildersoft.framework.services.BSMenuService;
import cl.buildersoft.framework.services.impl.BSMenuServiceImpl;
import cl.buildersoft.framework.util.BSHttpServlet;

/**
 * Servlet implementation class GetMenu
 */
@WebServlet(urlPatterns = "/servlet/login/GetMenuServlet")
public class GetMenuServlet extends BSHttpServlet {
	private static final long serialVersionUID = -4457825801379197051L;

	@SuppressWarnings("unchecked")
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		Connection conn = getConnection(request);

		String nextServlet = (String) request.getAttribute("NextServlet");

		List<Rol> rols = null;
		synchronized (session) {
			rols = (List<Rol>) session.getAttribute("Rol");
		}

		BSMenuService menuService = new BSMenuServiceImpl();

		Menu menu = menuService.getMenu(conn, rols, 1L);
		synchronized (session) {
			session.setAttribute("Menu", menu);
		}

		String page = nextServlet != null ? nextServlet : "/servlet/Home";
		forward(request, response, page);
		// request.getRequestDispatcher(page).forward(request, response);
	}

}
