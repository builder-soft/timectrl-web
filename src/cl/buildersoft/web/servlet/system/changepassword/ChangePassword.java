package cl.buildersoft.web.servlet.system.changepassword;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.beans.User;
import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.exception.BSUserException;
import cl.buildersoft.framework.util.BSSecurity;

@WebServlet("/servlet/system/changepassword/ChangePassword")
public class ChangePassword extends HttpServlet {
	private static final long serialVersionUID = -7579742240257360732L;

	public ChangePassword() {
		super();
	}

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String newPassword = request.getParameter("NewPassword");
		String commitPassword = request.getParameter("CommitPassword");
		String goHome = request.getParameter("GoHome");
		String oldPassword = null;
		// String currentPassword = null;

		if (!newPassword.equals(commitPassword)) {
			throw new BSUserException("0002", "Las claves no coinciden");
		}

		Long id = Long.parseLong(request.getParameter("cId"));

		BSmySQL mysql = new BSmySQL();
		Connection conn = mysql.getConnection(request.getServletContext(), "bsframework");

		BSBeanUtils bu = new BSBeanUtils();
		User user = new User();
		user.setId(id);
		bu.search(conn, user);
		String currentPasswordMD5 = user.getPassword();

		if (currentPasswordMD5 != null) {
			oldPassword = request.getParameter("OldPassword");

			String oldPasswordMD5 = md5(oldPassword);

			if (!currentPasswordMD5.equals(oldPasswordMD5)) {
				throw new BSUserException("0003", "La clave actual no conicide");
			}
		}

		newPassword = md5(newPassword);
		user.setPassword(newPassword);
		bu.update(conn, user);
		mysql.closeConnection(conn);

		String next = "/servlet/common/LoadTable";
		next = "/servlet/system/user/UserManager";
		if (goHome != null) {
			next = "/servlet/Home";
		}
		request.getRequestDispatcher(next).forward(request, response);

	}

	private String md5(String newPassword) {
		BSSecurity security = new BSSecurity();
		return security.md5(newPassword);
	}
}
