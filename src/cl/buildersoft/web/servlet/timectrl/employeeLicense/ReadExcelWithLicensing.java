package cl.buildersoft.web.servlet.timectrl.employeeLicense;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import cl.buildersoft.framework.business.services.EventLogService;
import cl.buildersoft.framework.business.services.ServiceFactory;
import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.exception.BSConfigurationException;
import cl.buildersoft.framework.exception.BSUserException;
import cl.buildersoft.framework.util.BSDateTimeUtil;
import cl.buildersoft.timectrl.business.beans.Employee;
import cl.buildersoft.timectrl.business.beans.License;
import cl.buildersoft.timectrl.business.beans.LicenseCause;
import cl.buildersoft.web.servlet.timectrl.employee.DetailFile;

public class ReadExcelWithLicensing {
	private static final Logger LOG = Logger.getLogger(ReadExcelWithLicensing.class.getName());
	private static final String[] MONTHS = { "ene", "feb", "mar", "abr", "may", "jun", "jul", "ago", "sep", "oct", "nov", "dic" };

	public static void main(String[] args) {
		ReadExcelWithLicensing rewl = new ReadExcelWithLicensing();
		rewl.doMain(args);
		System.exit(0);

	}

	public void doMain(String[] args) {
		LOG.entering(this.getClass().getName(), "doMain", args);
		LOG.log(Level.WARNING, "Method doMain of class {0} have hardcode", this.getClass().getName());
		String file = "D:\\cmoscoso\\Dropbox\\timectrl\\Reporte_permisos Junio 2014.xls";
		file = "E:\\Dropbox\\timectrl\\Reporte_permisos Junio 2014.xls";
		file = "E:\\Dropbox\\timectrl\\Reporte_permisos2014.xls";
		file = "C:\\Dropbox\\timectrl\\Reporte_permisos2014.xls";

		try {
			List<DetailFile> list = this.readFile(file);
			validateFile(getConnection(), list);

			for (DetailFile detail : list) {
				LOG.fine(detail.toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		LOG.exiting(this.getClass().getName(), "doMain");
	}

	public void validateFile(Connection conn, List<DetailFile> list) {
		BSBeanUtils bu = new BSBeanUtils();
		for (DetailFile detail : list) {
			validateType(conn, bu, detail);
			validateRut(conn, bu, detail);
			validateDate(conn, detail, detail.getStart());
			validateDate(conn, detail, detail.getEnd());
			if (detail.getMessage() == null) {
				validateRecord(conn, bu, detail);
			}
		}
	}

	private void validateRecord(Connection conn, BSBeanUtils bu, DetailFile detail) {
		License license = detailFileToLicense(conn, bu, detail);

		List<Object> params = new ArrayList<Object>();

		params.add(license.getEmployee());
		params.add(license.getLicenseCause());
		params.add(license.getDocument());
		params.add(license.getStartDate());
		params.add(license.getEndDate());

		BSmySQL mysql = new BSmySQL();
		ResultSet rs = mysql.callSingleSP(conn, "pExistsLicense", params);

		Boolean exists = false;
		try {
			if (rs.next()) {
				exists = rs.getInt(1) == 1;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			exists = false;
		}

		if (exists) {
			detail.setMessage("Licencia ya existe");
		}

	}

	private Long rutToId(Connection conn, BSBeanUtils bu, String rut) {
		Long out = null;
		Employee employee = new Employee();
		// String rut = detail.getRut();
		bu.search(conn, employee, "cRut=?", rut);
		out = employee.getId();

		return out;
	}

	private void validateDate(Connection conn, DetailFile detail, String date) {
		try {
			parseToCalendar(date);
		} catch (Exception e) {
			if (detail.getMessage() == null) {
				detail.setMessage("Fecha '" + date + "' no es valida");
			} else {
				detail.setMessage(detail.getMessage() + ", fecha '" + date + "' no es valida");
			}
		}
	}

	private Calendar parseToCalendar(String data) {
		String[] dateParts = data.split("[-]");
		Calendar date = Calendar.getInstance();
		date.set(Calendar.DAY_OF_MONTH, Integer.parseInt(dateParts[2]));
		date.set(Calendar.MONTH, Integer.parseInt(dateParts[1]) - 1);
		date.set(Calendar.YEAR, Integer.parseInt(dateParts[0]));

		return date;
	}

	private void validateRut(Connection conn, BSBeanUtils bu, DetailFile detail) {
		Employee employee = new Employee();
		detail.setRut(detail.getRut().trim());
		String rut = detail.getRut();
		if (!bu.search(conn, employee, "cRut=?", rut)) {
			detail.setMessage("Rut " + rut + " no encontrado");
		}
	}

	private void validateType(Connection conn, BSBeanUtils bu, DetailFile detail) {
		String sql = "SELECT COUNT(cId) AS cCount FROM tLicenseCause WHERE cName=?";
		String count = bu.queryField(conn, sql, detail.getType());
		if (Integer.parseInt(count) == 0) {
			LicenseCause licenseCause = new LicenseCause();
			licenseCause.setName(detail.getType());

			bu.insert(conn, licenseCause);
		}
	}

	protected Connection getConnection() {
		throw new BSConfigurationException("Method not implemented");

	}

	public List<DetailFile> readFile(String fileName) {
		File f = new File(fileName);
		FileInputStream file = null;
		try {
			file = new FileInputStream(f);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}

		XSSFWorkbook workbook = null;
		try {
			workbook = new XSSFWorkbook(file);
		} catch (Exception e) {
			String msg = "Archivo no es del formato esperado.";
			LOG.log(Level.SEVERE, msg, e);
			throw new BSUserException(msg);
			
		//	LOG.log(Level.SEVERE, e.getMessage(), e);
			//throw new BSUserException(e);
		}
		XSSFSheet sheet = workbook.getSheetAt(0);

		List<DetailFile> out = processRows(sheet);

		try {
			workbook.close();
			file.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return out;
	}

	private List<DetailFile> processRows(XSSFSheet sheet) {
		Integer i = 0;
		Integer j = 0;
		String data = null;
		List<DetailFile> out = new ArrayList<DetailFile>();

		Iterator<Row> rowIterator = sheet.iterator();
		while (rowIterator.hasNext()) {
			i++;
			Row row = rowIterator.next();
			if (i > 1) {
				DetailFile rowData = new DetailFile();
				rowData.setRowNumber(i);

				Iterator<Cell> cellIterator = row.cellIterator();
				j = 0;
				while (cellIterator.hasNext()) {
					j++;
					Cell cell = cellIterator.next();
					data = cell.toString();
					if (j == 1 || j == 2 || j == 7 || j == 8 || j == 11) {
						/**
						 * <code> 
					private static Integer type = 1;
					private static Integer rut = 2;
					private static Integer start = 7;
					private static Integer end = 8;
				</code>
						 */
						switch (j) {
						case 1:
							rowData.setType(data);
							break;
						case 2:
							rowData.setRut(data);
							break;
						case 7:
							rowData.setStart(parseDate(data));
							break;
						case 8:
							rowData.setEnd(parseDate(data));
							break;
						case 11:
							rowData.setDocument(data);
							break;
						default:
							break;
						}

					}

				}

				out.add(rowData);
			}

		}
		return out;
	}

	private String parseDate(String data) {
		String[] dateParts = data.split("[-]");
		String out = null;
		if (dateParts.length == 1) {
			out = data;
		} else {
			out = dateParts[2] + "-" + resolveMonth(dateParts[1]) + "-" + dateParts[0];
		}
		return out;
	}

	private int resolveMonth(String month) {
		Integer out = null;

		for (int i = 0; i < MONTHS.length; i++) {
			if (MONTHS[i].equals(month)) {
				out = i;
				break;
			}
		}
		if (out == null) {
			throw new NullPointerException("Month '" + month + "' was not found.");
		}
		return out + 1;
	}

	public void saveList(Connection conn, List<DetailFile> list, Long userId) {
		BSBeanUtils bu = new BSBeanUtils();
		EventLogService eventLog = ServiceFactory.createEventLogService();
		// License license =null;
		for (DetailFile detail : list) {
			if (detail.getMessage() == null) {
				saveDetail(conn, bu, detail);
				eventLog.writeEntry(conn, userId, "NEW_LICENSE",
						"Agregó licencia o permiso al empleado '%s' a través de archivo. Para el día %s al %s.", detail.getRut(),
						detail.getStart(), detail.getEnd());
			}
		}
	}

	private void saveDetail(Connection conn, BSBeanUtils bu, DetailFile detail) {
		License license = detailFileToLicense(conn, bu, detail);

		bu.insert(conn, license);
	}

	private License detailFileToLicense(Connection conn, BSBeanUtils bu, DetailFile detail) {
		License license = new License();
		license.setDocument(detail.getDocument());
		license.setEmployee(rutToId(conn, bu, detail.getRut()));

		Calendar calendar = parseToCalendar(detail.getStart());
		setZeroToTime(calendar);
		license.setStartDate(BSDateTimeUtil.calendar2Date(calendar));

		calendar = parseToCalendar(detail.getEnd());
		setZeroToTime(calendar);
		license.setEndDate(BSDateTimeUtil.calendar2Date(calendar));

		license.setLicenseCause(getLicenseCauseId(conn, bu, detail.getType()));
		return license;
	}

	private void setZeroToTime(Calendar calendar) {
		calendar.set(Calendar.HOUR, 0);
		calendar.set(Calendar.MINUTE, 0);
		calendar.set(Calendar.SECOND, 0);
		calendar.set(Calendar.MILLISECOND, 0);

	}

	private Long getLicenseCauseId(Connection conn, BSBeanUtils bu, String causeName) {
		LicenseCause licenseCause = new LicenseCause();
		bu.search(conn, licenseCause, "cName=?", causeName);
		return licenseCause.getId();
	}
}
