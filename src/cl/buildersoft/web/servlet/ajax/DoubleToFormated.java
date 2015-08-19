package cl.buildersoft.web.servlet.ajax;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.util.BSWeb;

@WebServlet("/servlet/ajax/DoubleToFormated")
public class DoubleToFormated extends AbstractAjaxServlet {
	private static final long serialVersionUID = -1937146590122545659L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String value = request.getParameter("Value");
		String out = null;
		Double valueDouble = null;
		try {
			valueDouble = Double.parseDouble(value);
			out = BSWeb.formatDouble(request, valueDouble);
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_NOT_FOUND);
			out = "NaN";
		}

		setHeaders(response);
		endWrite(writeToBrowser(response, out));
	}
}
