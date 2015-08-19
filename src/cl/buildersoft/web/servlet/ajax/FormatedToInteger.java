package cl.buildersoft.web.servlet.ajax;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.util.BSWeb;

@WebServlet("/servlet/ajax/FormatedToInteger")
public class FormatedToInteger extends AbstractAjaxServlet {
	private static final long serialVersionUID = 139721871849042522L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String value = request.getParameter("Value");
		String out = null;
		try {
//			Double number = Double.parseDouble(value);			
			out = "" + BSWeb.parseInteger(request, value);
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_NOT_FOUND);
			out = "NaN";
		}
		setHeaders(response);
		PrintWriter writer = writeToBrowser(response, out);
		endWrite(writer);

	}

}
