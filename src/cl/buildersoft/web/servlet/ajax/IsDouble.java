package cl.buildersoft.web.servlet.ajax;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/servlet/ajax/IsDouble")
public class IsDouble extends AbstractAjaxServlet {
	private static final long serialVersionUID = -6599087191525974198L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String value = request.getParameter("Value");
		String out = "true";
		try {
			Double.parseDouble(value);
		} catch (NumberFormatException e) {
			out = "false";
		}

		setHeaders(response);
		endWrite(writeToBrowser(response, out));
	}

}
