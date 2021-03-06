package cl.buildersoft.web.servlet.config.employee;

import java.sql.Connection;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.type.Semaphore;
import cl.buildersoft.framework.util.BSConfig;
import cl.buildersoft.framework.util.BSConnectionFactory;
import cl.buildersoft.framework.util.crud.BSAction;
import cl.buildersoft.framework.util.crud.BSActionType;
import cl.buildersoft.framework.util.crud.BSHttpServletCRUD;
import cl.buildersoft.framework.util.crud.BSTableConfig;

/**
 * Servlet implementation class EmployeeManager
 */
@WebServlet("/servlet/config/employee/EmployeeMarkManager")
public class EmployeeMarkManager extends BSHttpServletCRUD {
	private static final Logger LOG = Logger.getLogger(EmployeeMarkManager.class.getName());
	private static final long serialVersionUID = -7665593692157885850L;

	@Override
	protected BSTableConfig getBSTableConfig(HttpServletRequest request) {
		BSTableConfig table = initTable(request, "tEmployee", this);
		table.setSortField(getSortField(request));

		table.setTitle("Marcas de empleados");

		table.getField("cName").setLabel("Nombre");
		table.getField("cPost").setLabel("Cargo");
		table.getField("cArea").setLabel("Area");
		table.getField("cGroup").setLabel("Grupo");
		table.getField("cBoss").setLabel("Superior");
		table.getField("cPrivilege").setLabel("Tipo de usuario");
		// table.getField("cEnabled").setLabel("Activado");
		table.getField("cUsername").setLabel("Nombre Usuario");
		table.getField("cMail").setLabel("Correo electrónico");

		this.hideFields(table, "cMail", "cArea", "cPrivilege", "cBirthDate", "cAddress", "cComuna", "cCountry", "cGenere",
				"cPhone", "cMaritalStatus");
		table.removeField("cEnabled");

		table.removeAction("INSERT");
		table.removeAction("EDIT");
		table.removeAction("DELETE");

		table.setWhere("cEnabled=TRUE");

		BSAction action = new BSAction("TURNS", BSActionType.Record);
		action.setLabel("Asignación de Turnos");
		action.setUrl("/servlet/timectrl/employee/TurnsOfEmployee");
		// table.addAction(action);

		action = new BSAction("LICENSE", BSActionType.Record);
		action.setLabel("Licencias médicas o permisos");
		action.setUrl("/servlet/timectrl/employee/LicenseOfEmployee");
		// table.addAction(action);

		action = new BSAction("MARK_MODIFY", BSActionType.Record);
		action.setLabel("Administración de Marcas");
		action.setUrl("/servlet/timectrl/employee/MarkAdmin");
		action.setContext("TIMECTRL_CONTEXT");
		table.addAction(action);

		action = new BSAction("LOAD_LICENSE", BSActionType.Table);
		action.setLabel("Archivo Licencias");
		action.setUrl("/servlet/timectrl/employeeLicensing/LoadLicensing");
		// table.addAction(action);

		configEventLog(table, getCurrentUser(request).getId());

		return table;
	}

	private String getSortField(HttpServletRequest request) {
		BSConnectionFactory cf = new BSConnectionFactory();
		BSConfig config = new BSConfig();

		Connection conn = cf.getConnection(request);
		String out = config.getString(conn, "EMPLOYEE_ORDER");
		cf.closeConnection(conn);
		return out;
	}

	@Override
	public Semaphore setSemaphore(Connection conn, Object[] values) {
		LOG.entering(EmployeeMarkManager.class.getName(), "setSemaphore", values);
		Semaphore out = null;
		Long startTime = null;
		if (values != null) {
			BSmySQL mysql = new BSmySQL();

			String sql = "SELECT count(cId) FROM tR_EmployeeTurn WHERE cEmployee=?";
			startTime = System.currentTimeMillis();
			Integer cant = Integer.parseInt(mysql.queryField(conn, sql, values[0]));
			LOG.log(Level.FINE, "Load semaphore in {0}mm", System.currentTimeMillis() - startTime);
			mysql.closeSQL();
			if (cant == 0) {
				out = Semaphore.RED;
			} else {
				out = Semaphore.GREEN;
			}
		}
		LOG.exiting(EmployeeMarkManager.class.getName(), "setSemaphore", out);
		return out;
	}

	@Override
	protected void configEventLog(BSTableConfig table, Long userId) {

	}


}
