package cl.buildersoft.web.servlet.timectrl.employee;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.exception.BSException;
import cl.buildersoft.framework.util.BSConnectionFactory;
import cl.buildersoft.framework.web.servlet.BSHttpServlet_;
import cl.buildersoft.timectrl.business.beans.Area;
import cl.buildersoft.timectrl.business.beans.Employee;
import cl.buildersoft.timectrl.business.beans.LicenseCause;
import cl.buildersoft.timectrl.business.beans.Post;
import cl.buildersoft.timectrl.business.services.EmployeeService;
import cl.buildersoft.timectrl.business.services.impl.EmployeeServiceImpl;

@WebServlet("/servlet/timectrl/employee/NewLicenseForm")
public class NewLicenseForm extends BSHttpServlet_ {
	private static final Logger LOG = Logger.getLogger(NewLicenseForm.class.getName());
	private static final long serialVersionUID = NewLicenseForm.class.getName().hashCode();

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long employeeId = Long.parseLong(request.getParameter("cId"));

		BSConnectionFactory cf = new BSConnectionFactory();
		Connection conn = cf.getConnection(request);

		try {
			Employee employee = getEmployee(conn, employeeId);

			BSBeanUtils bu = new BSBeanUtils();
			
			EmployeeService service = new EmployeeServiceImpl();
			
			Post post = service.readPostOfEmployee(conn, employee);
			Area area = service.readAreaOfEmployee(conn, employee);
			
			request.setAttribute("LicenseCause", (List<LicenseCause>) bu.listAll(conn, new LicenseCause()));
			request.setAttribute("Employee", employee);
			request.setAttribute("Post", post);
			request.setAttribute("Area", area);
			
		} catch (BSException e) {
			LOG.log(Level.SEVERE, e.getMessage(), e);
		}finally{
			cf.closeConnection(conn);
		}
		forward(request, response, "/WEB-INF/jsp/timectrl/employee/new-license-form.jsp");

	}

	private Employee getEmployee(Connection conn, Long employeeId) {
		EmployeeService es = new EmployeeServiceImpl();
		Employee out = es.getEmployee(conn, employeeId);
		return out;
	}

}
