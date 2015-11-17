package cl.buildersoft.web.servlet.system.user;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cl.buildersoft.framework.beans.Domain;
import cl.buildersoft.framework.beans.DomainAttribute;
import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.exception.BSDataBaseException;
import cl.buildersoft.framework.util.BSDataUtils;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.web.servlet.login.ValidateLoginServlet;

@WebServlet("/servlet/system/user/ChangeDomain")
public class ChangeDomain extends BSHttpServlet {
	private static final long serialVersionUID = -5231577745476555171L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long id = Long.parseLong(request.getParameter("cId"));
		HttpSession session = request.getSession();
		// Connection conn = getConnection(request);
		BSDataUtils dau = new BSDataUtils();
		Connection conn = dau.getConnection2(getServletContext());

		List<Domain> domains = (List<Domain>) request.getSession().getAttribute("Domains");

		for (Domain domain : domains) {
			if (domain.getId().equals(id)) {
				session.setAttribute("Domain", domain);
				session.setAttribute("DomainAttribute", getDomainAttribute(conn, domain));
				break;
			}
		}

		forward(request, response, "/servlet/login/GetMenuServlet");
		// forward(request, response, "/servlet/Home");
	}

	private Map<String, DomainAttribute> getDomainAttribute(Connection conn, Domain defaultDomain) {
		ValidateLoginServlet validateLoginServlet = new ValidateLoginServlet();
		return validateLoginServlet.getDomainAttribute(conn, defaultDomain);
	}

}
