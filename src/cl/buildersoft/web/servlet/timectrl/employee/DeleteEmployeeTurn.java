package cl.buildersoft.web.servlet.timectrl.employee;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSmySQL;

@WebServlet("/servlet/timectrl/employee/DeleteEmployeeTurn")
public class DeleteEmployeeTurn extends HttpServlet {
	private static final long serialVersionUID = -5978358494434969344L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long employeeTurnId = Long.parseLong(request.getParameter("EmployeeTurn"));
		Long employee = Long.parseLong(request.getParameter("Employee"));

		String sql = "DELETE FROM tR_EmployeeTurn WHERE cId=?";
		BSmySQL mysql = new BSmySQL();
		Connection conn = mysql.getConnection(request);

		mysql.update(conn, sql, employeeTurnId);

		mysql.closeConnection(conn);

		request.setAttribute("cId", "" + employee);
		request.getRequestDispatcher("/servlet/timectrl/employee/TurnsOfEmployee").forward(request, response);

	}

}
