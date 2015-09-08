package cl.buildersoft.web.servlet.timectrl.report.execute;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.business.beans.Employee;
import cl.buildersoft.timectrl.business.services.EmployeeService;
import cl.buildersoft.timectrl.business.services.impl.EmployeeServiceImpl;

@WebServlet("/servlet/timectrl/report/execute/RetrieveEmployeeAjax")
public class RetrieveEmployeeAjax extends BSHttpServlet {
	private static final long serialVersionUID = 1L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String bossId = request.getParameter("BossId");

		Connection conn = getConnection(request);

		EmployeeService es = new EmployeeServiceImpl();
		List<Employee> list = es.listEmployeeByBoss(conn, Long.parseLong(bossId));

		request.setAttribute("EmployeeList", list);

		forward(request, response, "/WEB-INF/jsp/timectrl/report/execute/params/list-employees-by-boss-json.jsp");

	}

}
