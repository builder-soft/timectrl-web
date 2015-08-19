package cl.buildersoft.web.servlet.timectrl.employeeLicense;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import cl.buildersoft.framework.exception.BSConfigurationException;
import cl.buildersoft.framework.exception.BSProgrammerException;
import cl.buildersoft.framework.exception.BSSystemException;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.web.servlet.timectrl.employee.DetailFile;

/**
 * Servlet implementation class UploadLicenseFile
 */
@WebServlet("/servlet/timectrl/employeeLicense/UploadLicenseFile")
public class UploadLicenseFile extends BSHttpServlet {
	private static final int SIZE_15_MB = 1024 * 1024 * 15;
	private static final long serialVersionUID = -1220077678998963276L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String file = uploadFile(request);

		ReadExcelWithLicensing rewl = new ReadExcelWithLicensing();

		List<DetailFile> list = null;
		try {
			list = rewl.readFile(file);
		} catch (Exception e) {
			throw new BSProgrammerException(e);
		}
		Connection conn = getConnection(request);
		rewl.validateFile(conn, list);
		rewl.saveList(conn, list);

		request.setAttribute("ListFile", list);

		forward(request, response, "/WEB-INF/jsp/timectrl/employee/result-license-file.jsp");
	}

	@SuppressWarnings("unchecked")
	private String uploadFile(HttpServletRequest request) {
		FileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);
		String destinyFile = null;
		String tempFolder = this.getServletConfig().getServletContext().getAttribute("javax.servlet.context.tempdir").toString();

		System.out.println("File loaded in '" + tempFolder + "'");

		// Set overall request size constraint
		upload.setSizeMax(SIZE_15_MB);

		List<FileItem> items = null;
		try {
			items = upload.parseRequest(request);
		} catch (FileUploadException e) {
			e.printStackTrace();
			throw new BSSystemException(e);
		}

		Iterator<FileItem> iter = items.iterator();
		while (iter.hasNext()) {
			FileItem item = iter.next();

			// String fieldName = item.getFieldName();
			/**
			 * <code>
			String contentType = item.getContentType();
			boolean isInMemory = item.isInMemory();
			long sizeInBytes = item.getSize();
</code>
			 */
			if (!item.isFormField()) {
				/**
				 * <code>
				System.out.println(fieldName + "=" + item.getString());
			} else {
				System.out.println("FileName=" + fileName);
				System.out.println("ContentType=" + contentType);
				System.out.println("IsInMemory=" + isInMemory);
				System.out.println("SizeInBytes=" + sizeInBytes);
</code>
				 */
				String fileName = item.getName();
				// fileName =
				// "D:\\cmoscoso\\Dropbox\\timectrl\\Reporte_permisos Junio 2014.xls";
				fileName = fileName.substring(fileName.lastIndexOf(File.separator) + 1);
				destinyFile = tempFolder + File.separator + fileName;
				// System.out.println(destinyFile);

				File uploadedFile = new File(destinyFile);
				try {
					item.write(uploadedFile);
				} catch (Exception e) {
					e.printStackTrace();
					throw new BSConfigurationException(e);
				}
			}
		}
		return destinyFile;
	}
}
