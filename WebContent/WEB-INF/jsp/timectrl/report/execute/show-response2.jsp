<%@page import="java.io.File"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map.Entry"%>
<!-- 
http://www.codejava.net/java-ee/servlet/java-servlet-download-file-example
 -->

<%@ include file="/WEB-INF/jsp/common/header2.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu2.jsp"%>
<%
	Map<Integer, String> responseMap = (Map<Integer, String>) request.getAttribute("ResponseMap");
%>

<div class="page-header">
	<h1>Resultado de procesamiento</h1>
</div>


<div class="row">
	<table
		class="table table-striped table-bordered table-hover table-condensed">
		<thead>
			<tr>
				<td class='cHeadTD'>Archivo</td>
			</tr>
		</thead>
		<tbody>
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
							if (haveLink) {
					%> <a
					href="${pageContext.request.contextPath}/servlet/timectrl/report/execute/DownloadReport?idFile=<%=current.getKey().toString()%>&<%=BSWeb.randomString()%>"><%=fileName%></a>
					<%
						} else {
					%> <%=resp%> <%
 	}
 %>

				</td>
			</tr>
			<%
				}
			%>
		</tbody>
	</table>


	<button type="button" class='btn btn-link'
		onclick="javaScript:returnTo('${pageContext.request.contextPath}/servlet/timectrl/report/execute/ExecutionReport?<%=BSWeb.randomString()%>')">Aceptar</button>
		
<!-- 
<button class="javaScript:returnTo('${pageContext.request.contextPath}/servlet/timectrl/report/execute/ExecutionReport?<%=BSWeb.randomString()%>')">Aceptar</button>

	<a class="cCancel"
		href="${pageContext.request.contextPath}/servlet/timectrl/report/execute/ExecutionReport?<%=BSWeb.randomString()%>">Aceptar</a>
	 -->	
		
	<%@ include file="/WEB-INF/jsp/common/footer2.jsp"%>
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