package cl.buildersoft.web.servlet.ajax;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/servlet/ajax/IsEmail")
public class IsEmail extends AbstractAjaxServlet {
	private static final long serialVersionUID = 5101069628342758622L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String value = request.getParameter("Value");

		Pattern pattern = Pattern.compile(".+@.+\\.[a-z]+");
		Matcher matcher = pattern.matcher(value);

		String out = matcher.matches() ? "true" : "false";

		setHeaders(response);
		endWrite(writeToBrowser(response, out));
	}
}
