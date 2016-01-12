package cl.buildersoft.web.servlet.timectrl.files;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.util.BSConnectionFactory;
import cl.buildersoft.timectrl.business.beans.File;
import cl.buildersoft.timectrl.business.beans.FileContent;
import cl.buildersoft.web.servlet.common.AbstractServletUtil;

@WebServlet("/servlet/timectrl/files/DownloadFile")
public class DownloadFile extends AbstractServletUtil {
	private static final long serialVersionUID = 5707424258094726391L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long id = Long.parseLong(request.getParameter("cId"));

		BSBeanUtils bu = new BSBeanUtils();
		BSConnectionFactory cf = new BSConnectionFactory();
		Connection conn = cf.getConnection(request);

		// FileContent fileContent = ;
		File file = new File();
		file.setId(id);
		bu.search(conn, file);

		List<FileContent> fileContents = (List<FileContent>) bu.list(conn, new FileContent(), "cFile=? ORDER BY cOrder", id);
		cf.closeConnection(conn);

		ServletOutputStream output = configHeaderAsFile(response, file.getFileName().replaceAll(".csv", ".xls"));
		for (FileContent fileContent : fileContents) {
			String line = fileContent.getLine().replaceAll(";", "\t");
			output.println(line);
		}
		output.flush();
		output.close();
	}

}
