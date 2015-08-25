package cl.buildersoft.web.servlet.admin;

import java.sql.Connection;

import javax.servlet.Servlet;
import javax.servlet.http.HttpServletRequest;

import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.type.Semaphore;
import cl.buildersoft.framework.util.crud.BSAction;
import cl.buildersoft.framework.util.crud.BSActionType;
import cl.buildersoft.framework.util.crud.BSTableConfig;
import cl.buildersoft.web.servlet.common.HttpServletCRUD;
/**
 @ WebServlet("/servlet/admin/PersonManager")
 */
public class PersonManager extends HttpServletCRUD implements Servlet {
	private static final long serialVersionUID = 1504393587020193780L;

	public PersonManager() {
		super();
	}

	@Override
	protected BSTableConfig getBSTableConfig(HttpServletRequest request) {
		BSTableConfig table = initTable(request, "tPerson");

		BSmySQL mysql = new BSmySQL();
		Connection conn = mysql.getConnection(request);
		table.configFields(conn, mysql);
		mysql.closeConnection(conn);
		
		table.setSortField("cNombre");
		table.setTitle("Mantenedor de Pesonas");

		// BSField field;

		table.getField("cFechaRegistro").setLabel("Incorporaci�n");
		table.getField("cApellidoPaterno").setLabel("A. Paterno");
		table.getField("cApellidoMaterno").setLabel("A. Materno");

		/**
		 * table.getField("cComuna").setFK("bscommon", "tComuna", "cName");
		 * table.getField("cSexo").setFK("bscommon", "vSex", "cName");
		 */
		String[] noVisibleFields = { "cNumero", "cDireccion", "cDepartamento", "cVilla", "cBlock", "cMail" };
		for (String fieldName : noVisibleFields) {
			table.getField(fieldName).setVisible(false);
		}

		BSAction uploadFile = new BSAction("UPLOAD_PERSON", BSActionType.Table);
		uploadFile.setLabel("Carga por archivo");
		uploadFile.setUrl("/servlet/csv/UploadFile");
		table.addAction(uploadFile);

		BSAction download = new BSAction("DOWNLOAD_PERSON", BSActionType.Table);
		download.setLabel("Descargar como CSV");
		download.setUrl("/servlet/admin/PersonCSV");
		table.addAction(download);

		BSAction viewFKdetails = new BSAction("FK_DETAIL", BSActionType.Table);
		viewFKdetails.setLabel("Ver detalle de tablas secundarias");
		viewFKdetails.setUrl("/servlet/admin/PersonFK");
		table.addAction(viewFKdetails);

		return table;
	}

	@Override
	public Semaphore setSemaphore(Connection conn, Object[] values) {
		return null;
	}

}