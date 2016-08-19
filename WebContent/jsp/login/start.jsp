<%@page import="cl.buildersoft.framework.web.servlet.BSHttpServlet_"%>
<%
	BSHttpServlet_ hs = new BSHttpServlet_();
	hs.deleteSession(request, response);
	response.sendRedirect(getServletContext().getAttribute("DALEA_CONTEXT").toString());
%>