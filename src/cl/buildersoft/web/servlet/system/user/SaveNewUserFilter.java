package cl.buildersoft.web.servlet.system.user;

import static cl.buildersoft.framework.util.BSUtils.array2List;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import cl.buildersoft.framework.beans.Domain;
import cl.buildersoft.framework.beans.User;
import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.util.crud.BSTableConfig;

@WebFilter(urlPatterns = { "/servlet/common/InsertRecord" })
public class SaveNewUserFilter implements Filter  {
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException,
			ServletException {

		chain.doFilter(request, response);

		HttpServletRequest servletRequest = (HttpServletRequest) request;

		HttpSession session = servletRequest.getSession();
		BSTableConfig table = null;
		User user = null;
		Domain domain = null;
		synchronized (session) {
			table = (BSTableConfig) session.getAttribute("BSTable");
			user = (User) session.getAttribute("User");
			domain = (Domain) session.getAttribute("Domain");
		}

		if (!userAdmin(user) && table != null && table.getTableName().equalsIgnoreCase("tUser")) {
			Long domainId = domain.getId();
			Long newUserId = (Long) servletRequest.getAttribute("cId");

			if (newUserId != null && domainId != null) {
				BSmySQL mysql = new BSmySQL();
				Connection conn = mysql.getConnection(servletRequest);

				mysql.callSingleSP(conn, "bsframework.pSaveRUserDomain", array2List(newUserId, domainId));
				
				mysql.closeConnection(conn);
			}
		}
	}

	private boolean userAdmin(User user) {
		return user.getAdmin();
	}

	public void init(FilterConfig fConfig) throws ServletException {
	}

	@Override
	public void destroy() {
	}

}
