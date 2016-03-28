package cl.buildersoft.web.servlet.timectrl.employee;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.util.BSConnectionFactory;
import cl.buildersoft.framework.util.BSDateTimeUtil;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.business.beans.Area;
import cl.buildersoft.timectrl.business.beans.Employee;
import cl.buildersoft.timectrl.business.beans.License;
import cl.buildersoft.timectrl.business.beans.LicenseCause;
import cl.buildersoft.timectrl.business.beans.Post;
import cl.buildersoft.timectrl.business.services.EmployeeService;
import cl.buildersoft.timectrl.business.services.impl.EmployeeServiceImpl;

/**
 * Servlet implementation class LicenseOfEmployee
 */
@WebServlet("/servlet/timectrl/employee/LicenseOfEmployee")
public class LicenseOfEmployee extends BSHttpServlet {
	private static final long serialVersionUID = -4255968488922758974L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		/**
		 * <code>
		 
+---------------+-------------+------+-----+---------+----------------+
| Field         | Type        | Null | Key | Default | Extra          |
+---------------+-------------+------+-----+---------+----------------+
| cId           | bigint(20)  | NO   | PRI | NULL    | auto_increment |
| cEmployee     | bigint(20)  | NO   | MUL | NULL    |                |
| cStartDate    | date        | NO   |     | NULL    |                |
| cEndDate      | date        | NO   |     | NULL    |                |
| cLicenseCause | bigint(20)  | NO   | MUL | NULL    |                |
| cDocument     | varchar(15) | YES  |     | NULL    |                |
+---------------+-------------+------+-----+---------+----------------+

</code>
		 */

		Long employeeId = Long.parseLong(readParameterOrAttribute(request, "cId"));
//		Long employeeId = Long.parseLong(request.getParameter("cId"));
		BSConnectionFactory cf = new BSConnectionFactory();
		Connection conn = cf.getConnection(request);

		BSBeanUtils bu = new BSBeanUtils();
		@SuppressWarnings("unchecked")
		List<License> licenses = (List<License>) bu.list(conn, new License(), "cEmployee=?", employeeId);

		EmployeeService service = new EmployeeServiceImpl();

		Employee employee = getEmployee(conn, employeeId, service);
		Post post = service.readPostOfEmployee(conn, employee);
		Area area = service.readAreaOfEmployee(conn, employee);

		request.setAttribute("Licenses", licenses);
		request.setAttribute("LicenseCause", getLicenseCause(conn));
		cf.closeConnection(conn);
		
		request.setAttribute("Employee", employee);
		request.setAttribute("Post", post);
		request.setAttribute("Area", area);
		request.setAttribute("DateFormat", BSDateTimeUtil.getFormatDate(request));
		
		forward(request, response, "/WEB-INF/jsp/timectrl/employee/license-of-employee.jsp");
	 
	}

	private List<LicenseCause> getLicenseCause(Connection conn) {
		BSBeanUtils bu = new BSBeanUtils();
		@SuppressWarnings("unchecked")
		List<LicenseCause> causes = (List<LicenseCause>) bu.listAll(conn, new LicenseCause());
		return causes;
	}

	private Employee getEmployee(Connection conn, Long id, EmployeeService service) {
		return service.getEmployee(conn, id);
	}
}
