<%@page import="cl.buildersoft.timectrl.business.beans.IdRut"%>
<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>
<%
	String dateFormat = (String) request.getAttribute("DateFormat");
%>

<script type="text/javascript">
<!--
	function onLoadPage() {
		$("#StartDate").datepicker({
			dateFormat : fixDateFormat(dateFormat),
			appendText : " (" + dateFormat.toLowerCase() + ")",
			defaultDate : "-1m",
			changeMonth : true,
			numberOfMonths : 1,
			onSelect : function(selectedDate) {
				$("#EndDate").datepicker("option", "minDate", selectedDate);
			}
		});

		$("#EndDate").datepicker({
			dateFormat : fixDateFormat(dateFormat),
			appendText : " (" + dateFormat.toLowerCase() + ")",
			defaultDate : "-1m",
			changeMonth : true,
			numberOfMonths : 1,
			onSelect : function(selectedDate) {
				$("#StartDate").datepicker("option", "maxDate", selectedDate);
			}
		});
	}
//-->
</script>

<h1 class="cTitle">Listado Plano de asistencias</h1>

<form
	action="${pageContext.request.contextPath}/servlet/timectrl/report/builder/BuildPlainReport"
	method="post">
	<table>
		<tr>
			<td class="cLabel">Fecha Inicio:</td>
			<td><label class="cLabel"><input type="text" size="10"
					name="StartDate" id="StartDate"></label></td>
		</tr>
		<tr>
			<td class="cLabel">Fecha Término:</td>
			<td><label class="cLabel"><input type="text" size="10"
					name="EndDate" id="EndDate"> </label></td>
		</tr>
	</table>

	<button type="submit">Consultar</button>
</form>


<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>

