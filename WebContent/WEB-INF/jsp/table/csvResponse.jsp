<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<%@page import="cl.buildersoft.framework.type.BSData"%>
<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>
<%@ include file="/WEB-INF/jsp/table/functions.jsp"%>


<h1 class="cTitle">Respuesta del CSV</h1>
<div style="overflow: scroll; width: 1080px; height: 400px">
	<%
		List<Map<String, BSData>> respCSV = (List<Map<String, BSData>>) session
				.getAttribute("respCSV");
		out.println("<table class='cList' cellpadding='0' cellspacing='0'>");
		out.println("<tr>");

		String[] headers = (String[]) request.getAttribute("Headers");
		Integer rightCount = (Integer) request.getAttribute("RightCount");
		Integer totalCount = (Integer) request.getAttribute("RowCount");
		Integer wrongCount = totalCount - rightCount;

		for (String hearder : headers) {
			out.println("<td class='cHeadTD'>" + hearder.substring(1)
					+ "</td>");
		}
		out.println("</tr>");
		Integer rowCount = 0;
		for (Map<String, BSData> map : respCSV) {
			String color = ++rowCount % 2 != 0 ? "cDataTD" : "cDataTD_odd";
			out.println("<tr>");
			Iterator it = map.entrySet().iterator();
			Boolean isRowWrong = Boolean.FALSE;
			while (it.hasNext()) {
				Map.Entry<String, BSData> e = (Map.Entry<String, BSData>) it
						.next();
				if (!e.getKey().toString().equalsIgnoreCase("result")) {
					out.println("<td  class='"
							+ (!e.getValue().isState() ? "cErrorTD" : color)
							+ "' align='left'>");
					out.print(e.getValue().getValue());

					if (!isRowWrong) {
						isRowWrong = !e.getValue().isState();
					}

					out.println("</td>");
				}

			}

			out.println("</tr>");
		}
		out.println("</table>");
	%>
</div>
<span class="cLabel">Registros correctos:</span>
&nbsp;
<span class="cData"><%=rightCount%></span>
&nbsp;&nbsp;&nbsp;
<span class="cLabel">Registros erroneos:</span>
&nbsp;
<span class="cData"><%=wrongCount%></span>
&nbsp;&nbsp;&nbsp;
<span class="cLabel">Total de Registros:</span>
&nbsp;
<span class="cData"><%=totalCount%></span>

<form action="${pageContext.request.contextPath}/servlet/csv/ConfirmCSV"> 
<%
	if (totalCount.equals(rightCount)) {
%>
<span class="cLabel">La información es correcta</span>
<input type="submit" value="Confirmar" />
<a href="${pageContext.request.contextPath}/servlet/Home">Cancelar</a>
<%
	} else {
%>
<span class="cData">Corrija el archivo e intentelo de nuevo...</span>
<%
	}
%>
</form>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
