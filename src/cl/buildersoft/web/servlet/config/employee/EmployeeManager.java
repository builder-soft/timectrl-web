package cl.buildersoft.web.servlet.config.employee;

import java.sql.Connection;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import cl.buildersoft.framework.dataType.BSDataTypeEnum;
import cl.buildersoft.framework.dataType.BSDataTypeFactory;
import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.type.Semaphore;
import cl.buildersoft.framework.util.BSConfig;
import cl.buildersoft.framework.util.crud.BSAction;
import cl.buildersoft.framework.util.crud.BSActionType;
import cl.buildersoft.framework.util.crud.BSTableConfig;
import cl.buildersoft.web.servlet.common.HttpServletCRUD;

/**
 * Servlet implementation class EmployeeManager
 */
@WebServlet("/servlet/config/employee/EmployeeManager")
public class EmployeeManager extends HttpServletCRUD {
	private static final Logger LOG = Logger.getLogger(EmployeeManager.class.getName());
	private static final long serialVersionUID = -7665593692157885850L;

	@Override
	protected BSTableConfig getBSTableConfig(HttpServletRequest request) {
		BSTableConfig table = initTable(request, "tEmployee", this);
		table.setSortField(getSortField(request));

		BSDataTypeFactory dtf = new BSDataTypeFactory();

		table.getField("cFingerprint").setType(dtf.create(BSDataTypeEnum.TEXT));
		// table.getField("cFingerprint").setType(cl.buildersoft.framework.type.bst);
		table.setTitle("Mantención de empleados");
		// table.setDeleteSP("pDelEmployee");

		table.getField("cName").setLabel("Nombre");
		table.getField("cPost").setLabel("Cargo");
		table.getField("cArea").setLabel("Area");
		table.getField("cGroup").setLabel("Grupo");
		table.getField("cBoss").setLabel("Superior");
		table.getField("cPrivilege").setLabel("Tipo de usuario");
		table.getField("cEnabled").setLabel("Activado");
		table.getField("cUsername").setLabel("Nombre Usuario");
		table.getField("cMail").setLabel("Correo electrónico");

		// table.getField("cMail").setShowInTable(false);
		// table.getField("cArea").setShowInTable(false);
		// table.getField("cPrivilege").setShowInTable(false);

		// this.hideFields(table, "cArea", "cPrivilege", "cEnabled");
		this.hideFields(table, "cMail", "cArea", "cPrivilege", "cEnabled");

		// table.getField("cFingerprint").setReadonly(true);
		table.getField("cFingerprint").setShowInTable(false);
		table.getField("cFingerprint").setShowInForm(false);
		// table.getField("cFingerIndex").setReadonly(true);
		table.getField("cFingerIndex").setShowInTable(false);
		table.getField("cFingerIndex").setShowInForm(false);
		// table.getField("cFlag").setReadonly(true);
		table.getField("cFlag").setShowInTable(false);
		table.getField("cFlag").setShowInForm(false);
		// table.getField("cCardNumber").setReadonly(true);
		table.getField("cCardNumber").setShowInTable(false);
		table.getField("cCardNumber").setShowInForm(false);

		// table.getField("cBirthDate").setLabel("Nacimiento");
		/*
		 * table.getField("cAddress").setLabel("Dirección");
		 * table.getField("cGenere").setLabel("Género");
		 * table.getField("cCountry").setLabel("Nacionalidad");
		 * table.getField("cMaritalStatus").setLabel("Estado Civil");
		 */
		// table.getField("cKey").setReadonly(Boolean.TRUE);

		// table.getAction("EDIT").setLabel("Informacion Personal");

		BSAction action = new BSAction("TURNS", BSActionType.Record);
		action.setLabel("Asignación de Turnos");
		action.setUrl("/servlet/timectrl/employee/TurnsOfEmployee");
		// turnsAction.setUrl("/servlet/ShowParameters");
		table.addAction(action);

		action = new BSAction("LICENSE", BSActionType.Record);
		action.setLabel("Licencias médicas o permisos");
		action.setUrl("/servlet/timectrl/employee/LicenseOfEmployee");
		// turnsAction.setUrl("/servlet/ShowParameters");
		// action.setDisabled(true);
		table.addAction(action);

		action = new BSAction("MARK_MODIFY", BSActionType.Record);
		action.setLabel("Administración de Marcas");
		action.setUrl("/servlet/timectrl/employee/MarkAdmin");
		table.addAction(action);

		action = new BSAction("LOAD_LICENSE", BSActionType.Table);
		action.setLabel("Archivo Licencias");
		action.setUrl("/servlet/timectrl/employeeLicensing/LoadLicensing");
		table.addAction(action);

		/**
		 * <code>
		BSAction informationPrevitional = new BSAction("PREVITIONAL", BSActionType.Record);
		informationPrevitional.setLabel("Información Previsional");
		informationPrevitional.setUrl("/servlet/config/employee/InformationPrevitional");
		table.addAction(informationPrevitional);

		BSAction contractualInfo = new BSAction("CONTRACTUAL", BSActionType.Record);
		contractualInfo.setLabel("Información Contractual");
		contractualInfo.setUrl("/servlet/config/employee/ContractualInfo");
		table.addAction(contractualInfo);

		BSAction payMode = new BSAction("PAY_MODE", BSActionType.Record);
		payMode.setLabel("Forma de Pago");
		payMode.setUrl("/servlet/config/employee/PayMode");
		table.addAction(payMode);

		BSAction document = new BSAction("DOCUMENTS", BSActionType.Record);
		document.setLabel("Documentos");
		document.setUrl("/servlet/config/employee/DocumentEmployee");
		document.setMethod("listDocuments");
		table.addAction(document);
</code>
		 */
		return table;
	}

	private String getSortField(HttpServletRequest request) {
		BSmySQL mysql = new BSmySQL();
		BSConfig config = new BSConfig();

		Connection conn = mysql.getConnection(request);
		String out = config.getString(conn, "EMPLOYEE_ORDER");
		mysql.closeConnection(conn);
		return out;
	}

	@Override
	public Semaphore setSemaphore(Connection conn, Object[] values) {
		LOG.entering(EmployeeManager.class.getName(), "setSemaphore", values);
		Semaphore out = null;
		Long startTime = null;
		// values=null;
		if (values != null) {
			// if (false) {
			BSmySQL mysql = new BSmySQL();

			String sql = "SELECT count(cId) FROM tR_EmployeeTurn WHERE cEmployee=?";
			// Connection conn = mysql.getConnection(conn);
			startTime = System.currentTimeMillis();
			Integer cant = Integer.parseInt(mysql.queryField(conn, sql, values[0]));
			LOG.log(Level.FINE, "Load semaphore in {0}mm", System.currentTimeMillis() - startTime);
			mysql.closeSQL();
			// mysql.closeConnection(conn);
			if (cant == 0) {
				out = Semaphore.RED;
			} else {
				out = Semaphore.GREEN;
			}
		}
		LOG.exiting(EmployeeManager.class.getName(), "setSemaphore", out);
		return out;
	}
}
