package cl.buildersoft.web.servlet.timectrl.employeeLicense;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

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
	private static final Logger LOG = Logger.getLogger(UploadLicenseFile.class.getName());
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
		rewl.saveList(conn, list, getCurrentUser(request).getId());

		String page = bootstrap(conn) ? "/WEB-INF/jsp/timectrl/employee/result-license-file2.jsp"
				: "/WEB-INF/jsp/timectrl/employee/result-license-file.jsp";
		closeConnection(conn);

		request.setAttribute("ListFile", list);

		forward(request, response, page);
	}

	@SuppressWarnings("unchecked")
	private String uploadFile(HttpServletRequest request) {
		FileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);
		String destinyFile = null;
		String tempFolder = this.getServletConfig().getServletContext().getAttribute("javax.servlet.context.tempdir").toString();

		LOG.log(Level.INFO, "File loaded in {0}", tempFolder);

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
				String fileName = item.getName();
				fileName = fileName.substring(fileName.lastIndexOf(File.separator) + 1);
				destinyFile = tempFolder + File.separator + fileName;

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
