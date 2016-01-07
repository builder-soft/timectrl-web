package cl.buildersoft.web.servlet;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.util.BSHttpServlet;

@WebServlet("/servlet/ErrorHandler")
/**
 http://www.tutorialspoint.com/servlets/servlets-exception-handling.htm
 * */
public class ErrorHandler extends BSHttpServlet {
	private static final long serialVersionUID = 684616842L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Throwable throwable = (Throwable) request.getAttribute("javax.servlet.error.exception");
		Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
		String servletName = (String) request.getAttribute("javax.servlet.error.servlet_name");
		if (servletName == null) {
			servletName = "Unknown";
		}
		String requestUri = (String) request.getAttribute("javax.servlet.error.request_uri");
		if (requestUri == null) {
			requestUri = "Unknown";
		}

		Connection conn = getConnection(request);
		String page = bootstrap(conn) ? "/jsp/error/error2.jsp" : "/jsp/error/error.jsp";
		closeConnection(conn);
		
		forward(request, response, page);
	}

}
