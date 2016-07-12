<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="cl.buildersoft.timectrl.business.beans.Employee"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Turn"%>
<%@page import="cl.buildersoft.framework.util.BSDateTimeUtil"%>
<%@page import="cl.buildersoft.timectrl.business.beans.EmployeeTurn"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Post"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Area"%>
<%@ include file="/WEB-INF/jsp/common/header2.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu2.jsp"%>
<%
	Employee employee = (Employee) request.getAttribute("Employee");

	List<EmployeeTurn> employeeTurns = (List<EmployeeTurn>) request.getAttribute("EmployeeTurn");
	List<EmployeeTurn> exceptionTurns = (List<EmployeeTurn>) request.getAttribute("ExceptionTurn");
	String dateFormat = (String) request.getAttribute("DateFormat");
	List<Turn> turns = (List<Turn>) request.getAttribute("Turns");
	Boolean exception = (Boolean) request.getAttribute("Exception");
%>
<script
	src="${pageContext.request.contextPath}/js/timectrl/turn/turns-of-employee.js?<%=BSWeb.randomString()%>">
</script>
<script>
var exception = <%=exception%>;
</script>

<div class="page-header">
	<h1>Configuración de turnos</h1>
</div>

<c:import url="/servlet/dalea/web/GetEmployeeInfo" />
<!-- 
< % @ include file="/WEB-INF/jsp/timectrl/common/employee-info2_.jsp"% >
 -->


<ul class="nav nav-tabs">
	<li <%=exception?"": "class='active'"%>><a data-toggle="tab" href="#regular"
		onclick="javascript:toggleException(false)">Regulares</a></li>
	<li <%=exception?"class='active'":""%>><a data-toggle="tab" href="#exception"
		onclick="javascript:toggleException(true)">Excepcionales</a></li>
</ul>


<div class="tab-content">
	<div id="regular" class="tab-pane fade <%=exception?"": "in active"%>">
		<h2>Turnos regulares</h2>

		<table
			class="table table-striped table-bordered table-hover table-condensed"
			id="detailTable">
			<thead>
				<tr>
					<td>Turno</td>
					<td>Desde</td>
					<td>Hasta</td>
					<td>Acción</td>
				</tr>
			</thead>
			<%
				for (EmployeeTurn employeeTurn : employeeTurns) {
			%>
			<tbody>
				<tr>
					<td class='cDataTD'><%=employeeTurn.getTurnName()%></td>
					<td class='cDataTD'><%=BSDateTimeUtil.calendar2String(employeeTurn.getStartDate(), dateFormat)%></td>
					<td class='cDataTD'><%=BSDateTimeUtil.calendar2String(employeeTurn.getEndDate(), dateFormat)%></td>
					<td class='cDataTD'>
						<button
							onclick="javascript:editEmployeeTurn(this, <%=employeeTurn.getId()%>, <%=employeeTurn.getTurn()%>, '<%=BSDateTimeUtil.calendar2String(employeeTurn.getStartDate(), dateFormat)%>', '<%=BSDateTimeUtil.calendar2String(employeeTurn.getEndDate(), dateFormat)%>', <%=employeeTurn.getEmployee()%>)">Editar</button>
						<button
							onclick="javascript:deleteEmployeeTurn(<%=employeeTurn.getId()%>, <%=employee.getId()%>, '<%=employee.getName()%>')">Borrar</button>
					</td>
				</tr>
				<%
					}
				%>
			</tbody>
		</table>

	</div>

	<div id="exception" class="tab-pane fade <%=exception?"in active": ""%>">
		<h2>Turnos excepcionales</h2>

		<table
			class="table table-striped table-bordered table-hover table-condensed"
			id="exceptionTable">
			<thead>
				<tr>
					<td>Turno</td>
					<td>Desde</td>
					<td>Hasta</td>
					<td>Acción</td>
				</tr>
			</thead>
			<%
				for (EmployeeTurn employeeTurn : exceptionTurns) {
			%>
			<tbody>
				<tr>
					<td class='cDataTD'><%=employeeTurn.getTurnName()%></td>
					<td class='cDataTD'><%=BSDateTimeUtil.calendar2String(employeeTurn.getStartDate(), dateFormat)%></td>
					<td class='cDataTD'><%=BSDateTimeUtil.calendar2String(employeeTurn.getEndDate(), dateFormat)%></td>
					<td class='cDataTD'>
						<button
							onclick="javascript:editEmployeeTurn(this, <%=employeeTurn.getId()%>, <%=employeeTurn.getTurn()%>, '<%=BSDateTimeUtil.calendar2String(employeeTurn.getStartDate(), dateFormat)%>', '<%=BSDateTimeUtil.calendar2String(employeeTurn.getEndDate(), dateFormat)%>', <%=employeeTurn.getEmployee()%>)">Editar</button>
						<button
							onclick="javascript:deleteEmployeeTurn(<%=employeeTurn.getId()%>, <%=employee.getId()%>, '<%=employee.getName()%>')">Borrar</button>
					</td>
				</tr>
				<%
					}
				%>
			</tbody>
		</table>
	</div>

</div>
<button onclick="addNew(<%=employee.getId()%>);" id="addButton" class='btn btn-default'>Agregar
	Turno</button>

<button class='btn btn-link'
	onclick="returnTo('${pageContext.request.contextPath}/servlet/config/employee/EmployeeTurnManager');">Volver</button>

		<div id="TurnsContainer" style="display: none">
			<select id="DTurn">
				<%
					for (Turn turn : turns) {
				%>
				<option value="<%=turn.getId()%>"><%=turn.getName()%></option>
				<%
					}
				%>
			</select>
		</div>

<form id='form' method="post">
	<!-- Id del registro de la tabla tr_employeeturn -->
	<input type="hidden" name="TurnId" id="TurnId">
	<!-- Este valor no se ocupa, evaluar si se requiere, en caso contrario eliminar -->
	<input type="hidden" name="EmployeeTurn" id="EmployeeTurn">
	<!-- Id del empleado -->
	<input type="hidden" name="Employee" id="Employee">
	<!-- Id del turno, corresponde a la tabla tTurn -->
	<input type="hidden" name="Turn" id="Turn">
	<!-- fecha de inicio -->
	<input type="hidden" name="StartDate" id="StartDate">
	<!-- fecha de termino -->
	<input type="hidden" name="EndDate" id="EndDate">
	<!-- id del registro de la tabla de relacion, se utiliza para el update -->
	<input type="hidden" name="cId" id="cId">
	<!-- Campo que indica si es un turno excepcional -->
	<input type="hidden" name="Exception" id="Exception" value="<%=exception%>">
</form>

<%@ include file="/WEB-INF/jsp/common/footer2.jsp"%>
