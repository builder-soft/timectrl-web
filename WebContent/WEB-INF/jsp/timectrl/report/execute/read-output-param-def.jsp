<%@page import="cl.buildersoft.timectrl.business.beans.ReportPropertyBean"%>
<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>
<%
	List<ReportPropertyBean>  reportOutParamList=  (List<ReportPropertyBean> )request.getAttribute("ReportOutParamList");
%>
 <script
	src="${pageContext.request.contextPath}/js/timectrl/report/execute/read-output-param-def.js?<%=Math.random()%>">	
</script>

<h1 class="cTitle">Parametros de "${requestScope.ReportType.name}"</h1>

<table class="cList" cellpadding="0" cellspacing="0">
	<tr>
		<td class='cHeadTD'>Llave</td>
		<td class='cHeadTD'>Nombre</td>
	</tr>

	<%
		Integer i = 0;
		String color = "";
		for (ReportPropertyBean reportOutParam : reportOutParamList) {
			i++;
			color = i % 2 == 0 ? "cDataTD" : "cDataTD_odd";
	%>
	<tr>
		<td class='<%=color%>'>< %=reportOutParam.getKey() %></td>
		<td class='<%=color%>'>< %=reportOutParam.getName() %></td>
	</tr>
	<%
		}
	%>
</table>
<br><br>
<button onclick="javascript:addRecord()">Agregar</button>
<!-- <button onclick="">Modificar</button> -->
<button onclick="">Eliminar</button>

<a class="cCancel" href="${pageContext.request.contextPath}/servlet/timectrl/report/config/ReportTypeManager?<%=BSWeb.randomString()%>">Volver</a>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>

