package cl.buildersoft.web.servlet.system.user;

import java.sql.Connection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import cl.buildersoft.framework.beans.Domain;
import cl.buildersoft.framework.beans.User;
import cl.buildersoft.framework.type.Semaphore;
import cl.buildersoft.framework.util.crud.BSAction;
import cl.buildersoft.framework.util.crud.BSActionType;
import cl.buildersoft.framework.util.crud.BSField;
import cl.buildersoft.framework.util.crud.BSTableConfig;
import cl.buildersoft.web.servlet.common.HttpServletCRUD;

@WebServlet("/servlet/system/user/UserManager")
public class UserManager extends HttpServletCRUD {
	private static final long serialVersionUID = -3497399350893131897L;

	@Override
	protected BSTableConfig getBSTableConfig(HttpServletRequest request) {
		HttpSession session = request.getSession(false);

		Boolean isAdmin = null;
		User user = null;
		Domain domain = null;
		BSTableConfig table = null;
		synchronized (session) {
			user = (User) session.getAttribute("User");
			domain = (Domain) session.getAttribute("Domain");
			isAdmin = user.getAdmin();
		}

		BSField field = null;
		if (isAdmin) {
			table = new BSTableConfig("bsframework", "tUser", "vUserAdmin");
			table.setSaveSP("bsframework.pSaveUserAdmin");
		} else {
			table = new BSTableConfig(domain.getDatabase(), "tUser", "vUser");
			table.setSaveSP("bsframework.pSaveUser");
		}
		
		table.setTitle("Usuarios del sistema");
		table.setDeleteSP("pDeleteUser");

		field = new BSField("cId", "ID");
		field.setPK(true);
		table.addField(field);

		field = new BSField("cMail", "Mail");
		field.setTypeHtml("email");
		table.addField(field);

		field = new BSField("cName", "Nombre");
		table.addField(field);

		if (isAdmin) {
			field = new BSField("cAdmin", "Administrador");
			table.addField(field);

			BSAction domainRelation = new BSAction("ROL_DOMAIN", null);
			domainRelation.setNatTable("bsframework", "tR_UserDomain", "bsframework", "tDomain");
			domainRelation.setLabel("Dominios del usuario");
			table.addAction(domainRelation);
		}

		BSAction changePassword = new BSAction("CH_PASS", BSActionType.Record);
		changePassword.setLabel("Cambio de clave");
		changePassword.setUrl("/servlet/system/changepassword/SearchPassword");
		table.addAction(changePassword);

		BSAction rolRelation = new BSAction("ROL_RELATION", null);

//		Domain domain = (Domain) session.getAttribute("Domain");

		rolRelation.setNatTable(domain.getDatabase(), "tR_UserRol", domain.getDatabase(), "tRol");
		rolRelation.setLabel("Roles de usuario");
		table.addAction(rolRelation);

		return table;
	}

	@Override
	public Semaphore setSemaphore(Connection conn, Object[] values) {
		return null;	
	}
}
