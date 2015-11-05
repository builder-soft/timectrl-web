<%@page import="cl.buildersoft.framework.database.BSmySQL"%>
<%@page
	import="cl.buildersoft.timectrl.business.beans.ReportParameterBean"%>
<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>
<script
	src="${pageContext.request.contextPath}/js/timectrl/report/execute/params-report.js?<%=Math.random()%>">	
</script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/plugin/checkboxtree/0.5.2/jquery-ui-1.8.12.custom.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/plugin/checkboxtree/0.5.2/jquery.checkboxtree.js"></script>

<%
	List<ReportParameterBean> paramList = (List<ReportParameterBean>) request.getAttribute("ReportParameter");
%>


<h1 class="cTitle">${requestScope.Report.name}</h1>

<!-- 
<form action="${pageContext.request.contextPath}/servlet/ShowParameters" method="post">
 -->
<form
	action="${pageContext.request.contextPath}/servlet/timectrl/report/execute/BuildReport?<%=BSWeb.randomString() %>"
	method="post">

	<input type="hidden" name="ReportKey"
		value="${requestScope.Report.key}">
	<table width="50%">
		<%
			String component = null;
			for (ReportParameterBean param : paramList) {
				component = "/WEB-INF/jsp/timectrl/report/execute/params/" + param.getHtmlFile();
		%>

		<tr>
			<jsp:include page="<%=component%>">
				<jsp:param name="Label" value="<%=param.getLabel()%>" />
				<jsp:param name="Name" value="<%=param.getName()%>" />
				<jsp:param name="Key" value="<%=param.getTypeKey()%>" />
			</jsp:include>
		</tr>
		<%
			}
			//		(new BSmySQL()).closeSQL(rs);
		%>

	</table>

	<button type="submit" id="raiseQuery">Consultar</button>
	<a class="cCancel"
		href="${pageContext.request.contextPath}/servlet/timectrl/report/execute/ExecutionReport">Volver</a>

</form>


<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
