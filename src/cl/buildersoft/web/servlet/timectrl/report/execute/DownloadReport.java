package cl.buildersoft.web.servlet.timectrl.report.execute;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.util.BSHttpServlet;

@WebServlet("/servlet/timectrl/report/execute/DownloadReport")
public class DownloadReport extends BSHttpServlet {
	private static final long serialVersionUID = -5077833737463039976L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Integer idFile = Integer.parseInt(request.getParameter("idFile"));

		@SuppressWarnings("unchecked")
		Map<Integer, String> responseMap = (Map<Integer, String>) request.getSession(false).getAttribute("ResponseMap");
		String fileName = responseMap.get(idFile);

		File downloadFile = new File(fileName);
		FileInputStream fileInputStream = new FileInputStream(downloadFile);
		String mimeType = getServletContext().getMimeType(fileName);
		if (mimeType == null) {
			mimeType = "application/octet-stream";
		}
		response.setContentType(mimeType);
		response.setContentLength((int) downloadFile.length());
		String headerKey = "Content-Disposition";

		String headerValue = String.format("attachment; filename=\"%s\"", downloadFile.getName());
		response.setHeader(headerKey, headerValue);

		OutputStream outStream = response.getOutputStream();

		byte[] buffer = new byte[4096];
		int bytesRead = -1;

		while ((bytesRead = fileInputStream.read(buffer)) != -1) {
			outStream.write(buffer, 0, bytesRead);
		}

		fileInputStream.close();
		outStream.flush();
		outStream.close();

	}

}
