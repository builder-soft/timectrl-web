package cl.buildersoft.web.servlet.config.employee;

import java.sql.Connection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import cl.buildersoft.framework.type.Semaphore;
import cl.buildersoft.framework.util.crud.BSTableConfig;
import cl.buildersoft.timectrl.business.services.EventLogService;
import cl.buildersoft.timectrl.business.services.ServiceFactory;
import cl.buildersoft.web.servlet.common.HttpServletCRUD;

@WebServlet("/servlet/config/employee/PostManager")
public class PostManager extends HttpServletCRUD {
	private static final long serialVersionUID = -6279916596879232684L;

	@Override
	protected BSTableConfig getBSTableConfig(HttpServletRequest request) {
		BSTableConfig table = initTable(request, "tPost");
		table.setTitle("Administración de cargos");

		table.getField("cKey").setLabel("Llave");
		table.getField("cName").setLabel("Descripción");

		return table;
	}

	@Override
	public Semaphore setSemaphore(Connection conn, Object[] values) {
		return null;
	}

	@Override
	public String getBusinessClass() {
		return this.getClass().getName();
	}

	@Override
	public void writeEventLog(Connection conn, String action, HttpServletRequest request, BSTableConfig table) {
		EventLogService eventLog = ServiceFactory.createEventLogService();
		if ("INSERT".equalsIgnoreCase(action)) {
			eventLog.writeEntry(conn, getCurrentUser(request).getId(), "INSERT_POST", "Agrega nuevo cargo %s (%s)", table
					.getField("cName").getValue(), table.getField("cKey").getValue());
		}
		if ("UPDATE".equalsIgnoreCase(action)) {
			eventLog.writeEntry(conn, getCurrentUser(request).getId(), "UPDATE_POST",
					"Actualiza cargo, los datos eran: Key:'%s', Nombre:'%s', Id:%s", table.getField("cKey").getValue(), table
							.getField("cName").getValue(), table.getField("cId").getValue());
		}
		if ("DELETE".equalsIgnoreCase(action)) {
			eventLog.writeEntry(conn, getCurrentUser(request).getId(), "DELETE_POST",
					"Elimina cargo, los datos eran: Key:'%s', Nombre:'%s'", table.getField("cKey").getValue(), table
							.getField("cName").getValue());
		}
	}
}
