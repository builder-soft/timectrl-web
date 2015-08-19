package cl.buildersoft.web.servlet.timectrl.report.config;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.business.beans.ReportInputParameter;

/**
 * Servlet implementation class SaveParameterValue
 */
@WebServlet("/servlet/timectrl/report/config/SaveParameterValue")
public class SaveParameterValue extends BSHttpServlet {
	private static final long serialVersionUID = 3080538300402997426L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
/**
 <code>
Report
10
ParamId
Name
sdsadf
Label
asdfasdf
Type
2
Order
1 
  </code>
 * 
 * */		
		
		
		Long reportId = Long.parseLong(request.getParameter("Report"));
		String name = request.getParameter("Name");
		String label = request.getParameter("Label");
		Long type = Long.parseLong(request.getParameter("Type"));
//		String value = request.getParameter("Value");
//		Boolean fromUser = Boolean.parseBoolean(request.getParameter("FromUser"));
		Integer order = Integer.parseInt(request.getParameter("Order"));

		BSBeanUtils bu = new BSBeanUtils();
		ReportInputParameter rip = new ReportInputParameter();

//		rip.setFromUser(fromUser);
		rip.setName(name);
		rip.setLabel(label);
		rip.setOrder(order);
		rip.setReport(reportId);
		rip.setType(type);
//		rip.setValue(value == null ? "" : value);

		bu.save(getConnection(request), rip);
		request.setAttribute("cId", reportId.toString());

		forward(request, response, "/servlet/timectrl/report/config/ReportReadParameter");
	}
}
