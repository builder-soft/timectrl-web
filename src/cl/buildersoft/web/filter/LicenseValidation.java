package cl.buildersoft.web.filter;

import static cl.buildersoft.framework.util.BSUtils.array2ObjectArray;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.DispatcherType;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;

import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.exception.BSConfigurationException;
import cl.buildersoft.framework.exception.BSDataBaseException;
import cl.buildersoft.timectrl.util.LicenseValidationUtil;

@WebFilter(urlPatterns = { "/servlet/*" }, dispatcherTypes = { DispatcherType.REQUEST })
public class LicenseValidation implements Filter {
	private static final Logger LOG = Logger.getLogger(LicenseValidation.class.getName());
	private Boolean activeFilter = null;

	// private FilterConfig filterConfig = null;

	public void init(FilterConfig filterConfig) throws ServletException {
		if (activeFilter == null) {
			// this.filterConfig = filterConfig;
			ServletContext context = filterConfig.getServletContext();
			String activeFilterString = context.getInitParameter("bsframework.license.validate");
			try {
				this.activeFilter = Boolean.parseBoolean(activeFilterString);
			} catch (Exception e) {
				this.activeFilter = Boolean.TRUE;
				LOG.log(Level.WARNING, "Can't parsing {0} as Boolean value, will be {1}",
						array2ObjectArray(activeFilterString, this.activeFilter));

			}
		}
	}

	public void destroy() {

	}

	public void doFilter(ServletRequest rq, ServletResponse rs, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest) rq;

		Boolean success = true;

		if (activeFilter) {
			try {
				success = licenseValidation(request);
			} catch (Exception e) {
				e.printStackTrace();
				success = false;
			}

			/**
			 * <code>
			 * buscar licencia desde archivo 
			 * desencriptar archivo 
			 * split numeros de series 
			 * comparar series con los de la base de datos 
			 * SI ¿todas las series son correctas? ENTONCES 
			 * 		parsea fecha 
			 * 		SI la fecha actual > fecha de licencia THEN 
			 * 			calcula días vencidos 
			 * 			obtener random entre 1 y 100 
			 * 			SI dias vencidos >= numero random ENTONCES
			 * 				lanzar error 
			 * 			FIN SI 
			 * 		FIN SI 
			 * 	SINO 
			 * 		lanzar error 
			 * 	FIN SI
			 </code>
			 */

		}

		if (success) {
			chain.doFilter(rq, rs);
		} else {
			request.getSession().invalidate();
			throw new BSConfigurationException("Some configuration files are wrong!");
			// request.getRequestDispatcher(failUrl).forward(request,
			// response);
		}

	}

	private Boolean licenseValidation(HttpServletRequest request) {
		Connection conn = null;
		Boolean out = null;
		try {
			conn = getConnection(request);
		} catch (Exception e) {
			conn = null;
		}

		if (conn == null || closedConnection(conn)) {
			out = true;
		} else {
			String pathFile = request.getSession().getServletContext().getRealPath("/") + "WEB-INF" + File.separator
					+ "LicenseFile.dat";

			LicenseValidationUtil lv = new LicenseValidationUtil();
			String fileContent = lv.readFile(pathFile);
			out = lv.licenseValidation(conn, fileContent);
		}
		return out;
	}

	private boolean closedConnection(Connection conn) throws BSDataBaseException {
		try {
			return conn.isClosed();
		} catch (SQLException e) {
			throw new BSDataBaseException(e);
		}
	}

	private Connection getConnection(HttpServletRequest request) {
		BSmySQL mysql = new BSmySQL();
		Connection conn = mysql.getConnection(request);
		return conn;
	}

}
