package cl.buildersoft.web.filter;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

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
				System.out.println("Can't parsing '" + activeFilterString + "' as Boolean value");
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
			// System.out.println(serials + "   " + dateExpired);

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

	/**
	 * <code>
	private String getServerName(String url) {
		// https://localhost:8080/remcon-web/...
		Integer start = url.indexOf("//");
		Integer twoPoints = url.indexOf(":", start + 2);
		Integer slash = url.indexOf("/", start + 2);
		String out = null;

		if (twoPoints < 0) {
			out = url.substring(start + 2, slash);
		} else {
			out = url.substring(start + 2, twoPoints);
		}
		return out;
	}
</code>
	 */

	/**
	 * <code>
	private boolean validateLicense(String license) {
		Boolean validLicense = null;
		Double rnd = Math.random();
		rnd *= 100;
		Integer random = rnd.intValue() + 1;
		if (license == null || license.length() < 8) {
			validLicense = false;
		} else {
			Calendar expireDate = license2Calendar(license.substring(0, 8));
			Integer dateDiff = dateDiff(expireDate);

			validLicense = (random >= dateDiff);
			System.out.println("random: " + random + " >= dateDiff: " + dateDiff + " = " + validLicense);
		}
		return validLicense;
	}

	private Calendar license2Calendar(String license) {
		Calendar out = null;
		if (license.length() == 8) {
			String year = license.substring(0, 4);
			String month = license.substring(4, 6);
			String day = license.substring(6, 8);
			String date = year + "-" + month + "-" + day;

			System.out.println(date);

			if (BSDateTimeUtil.isValidDate(date, "yyyy-MM-dd")) {
				out = Calendar.getInstance();
				out.set(Calendar.YEAR, Integer.parseInt(year));
				out.set(Calendar.MONTH, Integer.parseInt(month) - 1);
				out.set(Calendar.DAY_OF_MONTH, Integer.parseInt(day));
			} else {
				out = Calendar.getInstance();
				out.set(Calendar.YEAR, 2000);
				out.set(Calendar.MONTH, 0);
				out.set(Calendar.DAY_OF_MONTH, 1);

			}

		}
		return out;
	}

	private Integer dateDiff(Calendar expireDate) {
		Integer out = 101;
		if (expireDate != null) {
			Calendar start = Calendar.getInstance();
			long diff = start.getTimeInMillis() - expireDate.getTimeInMillis();
			Long diffDays = diff / (24 * 60 * 60 * 1000);
			out = diffDays.intValue();
		}
		return out;
	}
</code>
	 */

}
