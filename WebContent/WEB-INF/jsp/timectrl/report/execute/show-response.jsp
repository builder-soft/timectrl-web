<%@page import="java.io.File"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map.Entry"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>
<%
	Map<Integer, String> responseMap = (Map<Integer, String>) request.getAttribute("ResponseMap");
%>

<h1 class="cTitle">Resultado de procesamiento</h1>

<table class="cList" cellpadding="0" cellspacing="0">
	<tr>
		<td class='cHeadTD'>Archivo</td>
	</tr>

	<%
		Integer index = 0;
		String color = null;
		Boolean haveLink = null;
		String fileName = null;
		Iterator entries = responseMap.entrySet().iterator();
		Entry current = null;
		String resp = null;
		

		while (entries.hasNext()) {
			current = (Entry) entries.next();

			index++;
			color = (index % 2 == 0 ? "cDataTD" : "cDataTD_odd");
			resp = (String) current.getValue();
			
			
			
	%>
	<tr>
		<td class='<%=color%>'>
		<%
		fileName = getFileName(resp);
		haveLink = !fileName.equals(resp);
		if(haveLink){
			%>
			<a href="${pageContext.request.contextPath}/servlet/timectrl/report/execute/DownloadReport?idFile=<%=current.getKey().toString()%>&<%=BSWeb.randomString()%>"><%=fileName%></a>
			<%
		}else{
			%>
			<%=resp%>
			<%
		}
		%>
		
		</td>
	</tr>
	<%
		}
	%>
</table>

<a class="cCancel"
	href="${pageContext.request.contextPath}/servlet/timectrl/report/execute/ExecutionReport?<%=BSWeb.randomString()%>">Aceptar</a>
<!-- 
http://www.codejava.net/java-ee/servlet/java-servlet-download-file-example
 -->
<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
<%!private String getFileName(String fileName) {
		String out = null;
		try {
			File file = new File(fileName);
			out = file.getName();
		} catch (NullPointerException e) {
			out = fileName;
		}
		return out;
	}%>
