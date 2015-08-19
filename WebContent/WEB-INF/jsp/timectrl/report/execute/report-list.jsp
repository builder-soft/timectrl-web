<%@page import="cl.buildersoft.timectrl.business.beans.Report"%>
<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>
<%
	List<Report> reportList = (List<Report>) request.getAttribute("ReportList");
%>
<h1 class="cTitle">Lista de reportes</h1>

<br>
<ul>
	<%
		for (Report report : reportList) {
	%>
	<li class="cLabel"><a href="${pageContext.request.contextPath}/servlet/timectrl/report/execute/ReadParameters?reportId=<%=report.getId()%>&_=<%=BSWeb.randomString()%>"><%=report.getName()%> </a></li>
	<%
		}
	%>
</ul>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
