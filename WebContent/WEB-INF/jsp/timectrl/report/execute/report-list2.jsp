<%@page import="cl.buildersoft.timectrl.business.beans.Report"%>
<%@ include file="/WEB-INF/jsp/common/header2.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu2.jsp"%>
<%
	List<Report> reportList = (List<Report>) request.getAttribute("ReportList");
%>
<div class="page-header">
<h1>Lista de reportes</h1>
</div>
<br>
<ul class="list-group">
	<%
		for (Report report : reportList) {
	%>
	 <li class="list-group-item"><a href="${pageContext.request.contextPath}/servlet/timectrl/report/execute/ReadParameters?reportId=<%=report.getId()%>&_=<%=BSWeb.randomString()%>"><%=report.getName()%> </a></li>
	<%
		}
	%>
</ul>

<%@ include file="/WEB-INF/jsp/common/footer2.jsp"%>
