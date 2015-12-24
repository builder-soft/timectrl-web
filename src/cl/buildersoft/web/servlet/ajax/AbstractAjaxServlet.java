package cl.buildersoft.web.servlet.ajax;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Connection;
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.util.BSConnectionFactory;

public abstract class AbstractAjaxServlet extends HttpServlet {
	private static final long serialVersionUID = 7962194037862243536L;

	protected Connection getConnection(HttpServletRequest request) {
		BSConnectionFactory cf = new BSConnectionFactory();
		return cf.getConnection(request);
	}

	protected void closeConnection(Connection conn) {
		(new BSmySQL()).closeConnection(conn);
	}

	protected void setHeaders(HttpServletResponse response) {
		response.setDateHeader("Date", new Date().getTime());
		response.setDateHeader("Expires", 0);
		response.setHeader("Cache-Control", "no-cache, must-revalidate, s-maxage=0, proxy-revalidate, private");
		response.setHeader("Pragma", "no-cache");
		response.setContentType("text/plain");
	}

	protected PrintWriter writeToBrowser(HttpServletResponse response, String out) throws IOException {
		PrintWriter writer = response.getWriter();
		writer.write(out);
		return writer;
	}

	protected void endWrite(PrintWriter writer) {
		writer.flush();
		writer.close();
	}

	protected Integer getParameterAsInteger(HttpServletRequest request, String name) {
		String parameter = request.getParameter(name);
		Integer out = null;
		if (parameter != null) {
			out = Integer.parseInt(parameter);
		}
		return out;
	}

	protected Long getParameterAsLong(HttpServletRequest request, String name) {
		String parameter = request.getParameter(name);
		Long out = null;
		if (parameter != null) {
			out = Long.parseLong(parameter);
		}
		return out;
	}

	protected BigDecimal getParameterAsBigDecimal(HttpServletRequest request, String name) {
		String parameter = request.getParameter(name);
		BigDecimal out = null;
		if (parameter != null) {
			out = new BigDecimal(parameter);
		}
		return out;
	}

}
