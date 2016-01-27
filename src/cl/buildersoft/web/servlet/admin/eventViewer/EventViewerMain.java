package cl.buildersoft.web.servlet.admin.eventViewer;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.beans.User;
import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.util.BSConnectionFactory;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.business.beans.EventType;

/**
 * Servlet implementation class EventViewerMain
 */
@WebServlet("/servlet/admin/eventViewer/EventViewerMain")
public class EventViewerMain extends BSHttpServlet {
	private static final long serialVersionUID = "/servlet/admin/eventViewer/EventViewerMain".hashCode();

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		BSConnectionFactory cf = new BSConnectionFactory();
		Connection conn = cf.getConnection(request);
		Connection connBS = cf.getConnection();

		BSBeanUtils bu = new BSBeanUtils();

		List<EventType> eventTypeList = (List<EventType>) bu.listAll(conn, new EventType());
		List<User> userList = (List<User>) bu.listAll(connBS, new User());

		request.setAttribute("EventTypeList", eventTypeList);
		request.setAttribute("UserList", userList);

		cf.closeConnection(conn);

		forward(request, response, "/WEB-INF/jsp/admin/event-viewer/event-viewer-main.jsp");
	}

}
