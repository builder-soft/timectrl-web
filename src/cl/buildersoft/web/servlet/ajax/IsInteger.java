package cl.buildersoft.web.servlet.ajax;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/servlet/ajax/IsInteger")
public class IsInteger extends AbstractAjaxServlet {
	private static final long serialVersionUID = 140858631840803247L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String value = request.getParameter("Value");
		String out = "true";
		try {
			Integer.parseInt(value);
		} catch (NumberFormatException e) {
			out = "false";
		}

		setHeaders(response);
		endWrite(writeToBrowser(response, out));
	}

}
