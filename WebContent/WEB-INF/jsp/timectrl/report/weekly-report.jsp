<%@page import="cl.buildersoft.timectrl.business.beans.IdRut"%>
<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>
<%
	List<IdRut> idRutList = (List<IdRut>) request.getAttribute("IdRutList");
%>

<h1 class="cTitle">Informe de Asistencia, separado por semanas</h1>

<form
	action="${pageContext.request.contextPath}/servlet/timectrl/report/builder/BuildWeeklyReport"
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
			<td class="cLabel">Mes:</td>
			<td><select name="Month">
					<option value="1">Enero</option>
					<option value="2">Febrero</option>
					<option value="3">Marzo</option>
					<option value="4">Abril</option>
					<option value="5">Mayo</option>
					<option value="6">Junio</option>
					<option value="7">Julio</option>
					<option value="8">Agosto</option>
					<option value="9">Septiembre</option>
					<option value="10">Octubre</option>
					<option value="11">Noviembre</option>
					<option value="12">Diciembre</option>
			</select></td>
		</tr>
		<tr>
			<td class="cLabel">Año:</td>
			<td><select name="Year">
					<option value="2014">2014</option>
					<option value="2015">2015</option>
			</select></td>
		</tr>
		<tr>
			<td class="cLabel">Destino usando 'UserName':</td>
			<td><select name="UseUsername"><option value="true">Si</option>
					<option value="false">No (Por centro de costo)</option></select></td>
		</tr>
	</table>

	<button type="submit">Generar</button>
</form>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>

