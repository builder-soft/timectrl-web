package cl.buildersoft.web.servlet.system.changepassword;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.beans.User;
import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.exception.BSUserException;
import cl.buildersoft.framework.util.BSConnectionFactory;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.framework.util.BSSecurity;
import cl.buildersoft.timectrl.business.services.EventLogService;
import cl.buildersoft.timectrl.business.services.ServiceFactory;

@WebServlet("/servlet/system/changepassword/ChangePassword")
public class ChangePassword extends BSHttpServlet {
	private static final long serialVersionUID = -7579742240257360732L;

	public ChangePassword() {
		super();
	}

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String newPassword = request.getParameter("NewPassword");
		String commitPassword = request.getParameter("CommitPassword");
		String goHome = request.getParameter("GoHome");
		Boolean reset = request.getParameter("Reset").equalsIgnoreCase("True");
		String oldPassword = null;
		// String currentPassword = null;
		EventLogService eventLog = ServiceFactory.createEventLogService();

		
		if (!newPassword.equals(commitPassword)) {
			throw new BSUserException("Las claves no coinciden");
		}

		Long id = Long.parseLong(request.getParameter("cId"));

		BSConnectionFactory cf = new BSConnectionFactory();
		Connection conn = cf.getConnection();

		BSBeanUtils bu = new BSBeanUtils();
		User user = new User();
		user.setId(id);
		bu.search(conn, user);
		String currentPasswordMD5 = user.getPassword();

		if (currentPasswordMD5 != null && !reset) {
			oldPassword = request.getParameter("OldPassword");

			String oldPasswordMD5 = md5(oldPassword);

			if (!currentPasswordMD5.equals(oldPasswordMD5)) {
				throw new BSUserException("La clave actual no conicide");
			}
		}

		Connection connDomain = cf.getConnection(request);
		eventLog.writeEntry(connDomain, getCurrentUser(request).getId(), "SECURITY_CH_PASS", "Cambio la password de %s",
				user.getMail());
		cf.closeConnection(connDomain);

		newPassword = md5(newPassword);
		user.setPassword(newPassword);
		bu.update(conn, user);
		cf.closeConnection(conn);

		String next = "/servlet/common/LoadTable";
		next = "/servlet/system/user/UserManager";
		if (goHome != null) {
			next = "/servlet/Home";
		}
		forward(request, response, next);

	}

	private String md5(String password) {
		BSSecurity security = new BSSecurity();
		return security.md5(password);
	}
}
