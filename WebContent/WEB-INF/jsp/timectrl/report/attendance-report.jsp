<%@page import="cl.buildersoft.timectrl.business.beans.IdRut"%>
<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>
<%
	List<IdRut> idRutList = (List<IdRut>) request.getAttribute("IdRutList");
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


<h1 class="cTitle">Informe de Asistencia</h1>

<form
	action="${pageContext.request.contextPath}/servlet/timectrl/report/builder/BuildAttendanceReport"
	method="post">
	<table>
		<tr>
			<td class="cLabel">Empleado:</td>
			<td><select name="Employee">
					<option value="0">- Todos los empleados -</option>
					<%
						for (IdRut idRut : idRutList) {
					%>
					<option value="<%=idRut.getId()%>"><%=idRut.getRut()%>
						-
						<%=idRut.getName()%></option>
					<%
						}
					%>
			</select></td>
		</tr>
		<tr>
			<td class="cLabel">Fecha Inicio:</td>
			<td><label class="cLabel"><input type="text"
					name="StartDate" id="StartDate"></label></td>
		</tr>
		<tr>
			<td class="cLabel">Fecha Término:</td>
			<td><label class="cLabel"><input type="text"
					name="EndDate" id="EndDate"> </label></td>
		</tr>
		<tr>
			<td class="cLabel">Destino usando 'UserName':</td>
			<td><select name="UseUsername"><option value="true">Si</option>
					<option value="false">No (Por centro de costo)</option></select></td>
		</tr>
	</table>

	<button type="submit">Consultar</button>
</form>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>

