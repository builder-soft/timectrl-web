<%@page import="cl.buildersoft.timectrl.business.beans.ReportPropertyBean"%>
<%@page
	import="cl.buildersoft.timectrl.business.beans.ReportPropertyType"%>
<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>

<%
	List<ReportPropertyBean> values = (List<ReportPropertyBean>) request.getAttribute("Properties");
	//Connection conn = (Connection) request.getAttribute("Connection");
%>

<script
	src="${pageContext.request.contextPath}/js/timectrl/report/config/report-read-properties.js">
	
</script>

<h1 class="cTitle">Configuración de propiedades de Reporte.</h1>

<%@ include file="/WEB-INF/jsp/timectrl/report/config/report-info.jsp"%>


<form
	action="${pageContext.request.contextPath}/servlet/timectrl/report/config/SavePropertyValue"
	_action="${pageContext.request.contextPath}/servlet/ShowParameters"
	method="post">

	<input type="hidden" name="ReportId" value="${requestScope.Report.id}">
	<table border="0" id="tableValues">
		<%
			for (ReportPropertyBean value : values) {
		%>
		<tr>
			<td class="cLabel"><%=value.getPropertyTypeName()%>(<%=value.getPropertyTypeKey()%>):</td>
			<td><input type="text" name="Param#<%=value.getPropertyId()%>"
				value="<%=value.getPropertyValue() == null ? "" : value.getPropertyValue()%>"></td>
		</tr>
		<%
			}
		%>
	</table>

	<br>

	<button type="submit" _onclick="javascript:saveValues()">Grabar</button>

	<a class="cCancel"
		href="${pageContext.request.contextPath}/servlet/timectrl/report/config/ReportManager">Volver</a>
</form>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
