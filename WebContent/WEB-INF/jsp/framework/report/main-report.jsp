<%@page import="cl.buildersoft.timectrl.type.BSParamReportType"%>
<%@page import="cl.buildersoft.timectrl.business.beans.BSParamReport"%>
<%@page import="java.util.SortedMap"%>
<%@page import="cl.buildersoft.framework.report.BSReport"%>

<%
	BSReport report = (BSReport) request.getSession(false).getAttribute("BSReport");
	List<BSParamReport> params = report.listParamReport();
	String[] heads = (String[]) request.getAttribute("Heads");
	List<String[]> data = (List<String[]>) request.getAttribute("Data");
%>

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>

<script
	src="${pageContext.request.contextPath}/js/framework/report/main-report.js">	
</script>

<script type="text/javascript">
function validate(){
var doSubmit = true;
<%Integer index = 0;
BSParamReportType type = null;
Boolean required = null;
for (BSParamReport param : params) {
	type = param.getParamType();
	required = param.getRequired();
	if(required){
		if(type.equals(BSParamReportType.DATE)){
		%>
			doSubmit = isDate(document.getElementById('<%=param.getName()%>').value);
			if(!doSubmit){
				alert("El campo '<%=param.getLabel()%>' no es válido");
				return false;
			}
			
<%
	}
		}
}%>
return true;
}
</script>

<h1 class="cTitle"><%=report.getTitle()%></h1>

<form action="${pageContext.request.contextPath}<%=report.getUri()%>"
	method="post" id="reportForm">
	<table border="0">
		<tr>
			<%
				index = 0;
				for (BSParamReport param : params) {
			%>
			<%=writeParameter(request, param)%>
			<%
				index++;
					if (index % 2 == 0) {
			%>
		</tr>
		<tr>
			<%
				} else {
			%><td style='width: 50px'></td>
			<%
				}
				}
			%>
		</tr>
	</table>
	<button type="button" onclick="javascript:run()">Buscar</button>

	<%
		if (heads != null) {
	%>
	<button type="button" onclick="javascript:download()" onclick="">Descargar</button>
	<%
		}
	%>

</form>

<%
	if (heads != null) {
%>
<table class="cList" cellpadding="0" cellspacing="0">
	<tr>
		<%
			for (String head : heads) {
		%>
		<td class="cHeadTD"><%=head%></td>
		<%
			}
		%>
	</tr>
	<%
		index = 0;
			String color = "";
			for (String[] row : data) {
				color = index++ % 2 == 0 ? "cDataTD_odd" : "cDataTD";
	%>
	<tr>
		<%
			for (String cell : row) {
		%>
		<td class="<%=color%>"><%=cell == null ? "" : cell%></td>
		<%
			}
		%>
	</tr>
	<%
		}
	%>
</table>
<%
	}
%>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>

<%!private String writeParameter(HttpServletRequest request, BSParamReport param) {
		String out = "<td class='cLabel'>" + (param.getRequired() ? "&nbsp;(*)&nbsp;" : "") + param.getLabel() + ":</td><td>";
		String paramValue = "";
		String currentValue = param.getValue() == null ? "" : param.getValue();
		BSParamReportType type = param.getParamType();

		if (type.equals(BSParamReportType.TEXT)) {
			paramValue = "<input type='text' id='" + param.getName() + "' name='" + param.getName() + "'>";
		} else if (type.equals(BSParamReportType.DATE)) {
			String formatDate = (String) request.getAttribute("DateFormat");

			paramValue = "<input type='text' id='" + param.getName() + "' name='" + param.getName()
					+ "' size='10' maxlength='10' onblur='javascript:dateBlur(this);' value='" + currentValue
					+ "'><span class='cLabel'> (" + formatDate + ")</span>";
		} else if (type.equals(BSParamReportType.INTEGER)) {
			String min = param.getMin();
			String max = param.getMax();
			paramValue = "<input type='number' id='" + param.getName() + "' name='" + param.getName() + "' size='10' min='" + min
					+ "' max='" + max + "'>";
		} else if (type.equals(BSParamReportType.SELECT)) {
			paramValue = "<select id='" + param.getName() + "' name='" + param.getName() + "'>";

			List<String[]> options = param.listOptions();
			for (String[] option : options) {
				paramValue += "<option value='" + option[0] + "'" + (option[0].equals(currentValue) ? " selected " : "") + ">"
						+ option[1] + "</option>\n";
			}
			paramValue += "</select>";
		}
		//		TEXT, DATE, SELECT, INTEGER, DECIMAL, MULTISELECT

		out += paramValue;
		out += "</td>\n";

		return out;
	}%>