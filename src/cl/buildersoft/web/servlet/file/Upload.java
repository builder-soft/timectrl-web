package cl.buildersoft.web.servlet.file;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.catalina.util.Base64;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import cl.buildersoft.business.beans.DatabaseFile;
import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.exception.BSSystemException;

@WebServlet("/servlet/file/Upload")
public class Upload extends HttpServlet {
	private static final long serialVersionUID = 2079784430584398750L;

	public Upload() {
		super();

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("/WEB-INF/jsp/common/no-access.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// String desc = request.getParameter("desc");
		FileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);

		List<FileItem> items = null;
		try {
			items = upload.parseRequest(request);
		} catch (FileUploadException e) {
			throw new BSSystemException(e);
		}
		PrintWriter w = response.getWriter();
		DatabaseFile file = new DatabaseFile();
		for (FileItem item : items) {
			if (item.isFormField()) {
				String name = item.getFieldName();
				String value = item.getString();
				w.println(name + "=" + value);

				file.setDesc(value);
			} else {
				w.println("size:" + (item.getSize() / 1024) + "kb");
				w.println("type:" + item.getContentType());
				w.println("name:" + item.getName());
				w.println("IsInMemory:" + item.isInMemory());

				file.setContent(Base64.encode(item.get()));
				file.setFileName(item.getName());

				file.setSize(item.getSize());

				w.print("\n\n");

			}

		}
		w.flush();

		BSmySQL mysql = new BSmySQL();
		Connection conn = mysql.getConnection(request);

		BSBeanUtils bu = new BSBeanUtils();
		bu.insert(conn, file);
		mysql.closeConnection(conn);
	}
}
