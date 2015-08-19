package cl.buildersoft.web.servlet.ajax;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.util.BSDateTimeUtil;

@WebServlet("/servlet/ajax/IsDate")
public class IsDate extends AbstractAjaxServlet {
	private static final long serialVersionUID = -4907796524707494142L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String value = request.getParameter("Value");
		String out = "true";

		String format = BSDateTimeUtil.getFormatDate(request);
		if (!BSDateTimeUtil.isValidDate(value, format)) {
			out = "false";
		}

		setHeaders(response);
		endWrite(writeToBrowser(response, out));
	}

}
