<%@page import="java.util.Enumeration"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>

<%
	try {
		HttpSession s = request.getSession(false);
		HttpSessionContext sc = s.getSessionContext();
		Enumeration ids = sc.getIds();
		while (ids.hasMoreElements()) {
			String id = (String) ids.nextElement();
			HttpSession theSession = sc.getSession(id);
			theSession.invalidate();
		}

	} catch (Exception e) {
		e.printStackTrace();
	}
%>

<h1 class="cTitle">Contenido...</h1>

<form action="${pageContext.request.contextPath}/servlet/ShowParameters">
	<input type="radio" name="sex" value="male" /> Male<br /> <input
		type="radio" name="sex" value="female" /> Female<br /> <input
		type="submit">
</form>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>

