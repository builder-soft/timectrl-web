<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>
<%
	//String dateFormat = (String) request.getAttribute("DateFormat");
%>
<script type="text/javascript">
<!--
	function onLoadPage() {
		$("#AbsenceDate").datepicker({
			dateFormat : fixDateFormat(dateFormat),
			appendText : " (" + dateFormat.toLowerCase() + ")",
			defaultDate : "-1m",
			changeMonth : true,
			numberOfMonths : 1,
			 
		});

		 
	}
//-->
</script>
<h1 class="cTitle">Informe de Inasistencias</h1>

<form
	action="${pageContext.request.contextPath}/servlet/timectrl/report/builder/BuildAbsenceReport"
	method="post">
	<table>
		<tr>
			<td class="cLabel">Fecha a consultar:</td>
			<td><label
				class="cLabel"><input type="text" name="AbsenceDate" id="AbsenceDate"> 
			</label></td>
		</tr>
	</table>

	<button type="submit">Consultar</button>
</form>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>

