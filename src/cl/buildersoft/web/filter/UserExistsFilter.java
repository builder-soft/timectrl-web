package cl.buildersoft.web.filter;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.DispatcherType;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet Filter implementation class UserExists
 */
@WebFilter(urlPatterns = { "/servlet/*" }, dispatcherTypes = { DispatcherType.REQUEST, DispatcherType.FORWARD })
public class UserExistsFilter implements Filter {
	private static final Logger LOG = Logger.getLogger(UserExistsFilter.class.getName());

	public UserExistsFilter() {
	}

	public void destroy() {
	}

	public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain) throws IOException,
			ServletException {
		HttpServletRequest request = (HttpServletRequest) servletRequest;
		HttpServletResponse response = (HttpServletResponse) servletResponse;
		Boolean goHome = Boolean.FALSE;

		LOG.log(Level.FINE, "URI: {}", request.getRequestURI());

		HttpSession session = request.getSession(false);

		if (session == null) {
			goHome = Boolean.TRUE;
		} else {
			Object user = session.getAttribute("User");
			Object rol = session.getAttribute("Rol");
			Object menu = session.getAttribute("Menu");
			if (user == null || rol == null || menu == null) {
				goHome = Boolean.TRUE;
			}
		}

		if (goHome) {
			response.sendRedirect(request.getContextPath());
		} else {
			chain.doFilter(servletRequest, servletResponse);
		}
	}

	public void init(FilterConfig fConfig) throws ServletException {
	}
}
