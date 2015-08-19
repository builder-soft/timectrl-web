<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>
<%
	Object messageObject = request.getAttribute("Message");
	String message = messageObject == null ? "" : (String) messageObject;
%>

<h1 class="cTitle"><%=message%></h1>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>

