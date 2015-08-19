package cl.buildersoft.web.open;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/open/Info")
public class Info extends HttpServlet {
	private static final long serialVersionUID = -1699386952151622834L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		/**
		 * <code>
		public void printHeader(HttpServletRequest request,
			      HttpServletResponse response) throws IOException, ServletException {
</code>
		 */
		String headers = null;
		String htmlHeader = "<HTML><HEAD><TITLE> Request Headers</TITLE></HEAD><BODY>";
		String htmlFooter = "</BODY></HTML>";

		response.setContentType("text/html");

		PrintWriter out = response.getWriter();
		Enumeration<String> e = request.getHeaderNames();

		out.println(htmlHeader);
		out.println("<TABLE ALIGN=CENTER BORDER=1>");
		out.println("<tr><th> Header </th><th> Value </th>");

		while (e.hasMoreElements()) {
			headers = (String) e.nextElement();
			if (headers != null) {
				out.println("<tr><td align=center><b>" + headers + "</td>");
				out.println("<td align=center>" + request.getHeader(headers) + "</td></tr>");
			}
		}
		out.println("</TABLE><BR>");
		out.println(htmlFooter);

	}

}
