<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>

<h1 class="cTitle">Lista de parámetros</h1>

<%
	Map<Long, Map<String, Object>> data = (Map<Long, Map<String, Object>>) request
			.getAttribute("Data");

	//out.print(rs.isClosed());
%>
<a class="clabel">
<%

Iterator it = data.entrySet().iterator();

while (it.hasNext()) {
	Object r = it.next();
	%>
	<%=r%>
<%
}
%>
 </a>
<hr>
<table class="cList" cellpadding="0" cellspacing="0">
	<tr>
		<td class='cHeadTD'>encabezado</td>
	</tr>
	<tr>
		<td class='cDataTD'>dato</td>
	</tr>
	<tr>
		<td class='cDataTD_odd'>dato</td>
	</tr>
</table>


<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>

