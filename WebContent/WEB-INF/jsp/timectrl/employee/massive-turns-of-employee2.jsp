<%@page import="cl.buildersoft.timectrl.business.beans.Turn"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Employee"%>
<%@ include file="/WEB-INF/jsp/common/header2.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu2.jsp"%>
<%
	List<Employee> employeeList = (List<Employee>) request.getAttribute("EmployeeList");

	//	List<EmployeeTurn> employeeTurns = (List<EmployeeTurn>) request.getAttribute("EmployeeTurn");
	//	List<EmployeeTurn> exceptionTurns = (List<EmployeeTurn>) request.getAttribute("ExceptionTurn");
	String dateFormat = (String) request.getAttribute("DateFormat");
	List<Turn> turns = (List<Turn>) request.getAttribute("Turns");
%>
<script
	src="${pageContext.request.contextPath}/js/timectrl/turn/massive-turns-of-employee.js?<%=BSWeb.randomString()%>">
</script>

<div class="page-header">
	<h1>Asignacion Masiva de turnos</h1>
</div>

<form 
_action="${pageContext.request.contextPath}/servlet/ShowParameters" 
action="${pageContext.request.contextPath}/servlet/timectrl/employee/SaveNewMassiveTurn" 
method="post">
<div class="row">
	<div class="col-sm-12">
		<table
			class="table table-striped table-bordered table-hover table-condensed table-responsive">
			<caption>Lista de Emploeados:</caption>
			<thead>
				<tr>
					<th>Llave</th>
					<th>Rut</th>
					<th>Nombre</th>
				</tr>
			</thead>
			<tbody>
				<%
					for (Employee employee : employeeList) {
				%>
				<tr>
					<td><input type="hidden" name="Employee" value="<%=employee.getId()%>"><%=employee.getKey()%></td>
					<td><%=employee.getRut()%></td>
					<td><%=employee.getName()%></td>
				</tr>
				<%
					}
				%>
			</tbody>
		</table>
	</div>
</div>

<div class="well">
<div class="row">
	<div class="col-sm-12">
		<div class="col-sm-offset-1 col-sm-2">
			<label for="DTurn">Turno:</label>
		</div>
		<div class="col-sm-8">
			<select id="Turn" name="Turn">
				<%
					for (Turn turn : turns) {
				%>
				<option value="<%=turn.getId()%>"><%=turn.getName()%></option>
				<%
					}
				%>
			</select>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-sm-12">
		<div class="col-sm-offset-1 col-sm-2 ">
			<label for="StartDate">Desde:</label>
		</div>
		<div class="col-sm-8 ">
			<input type="text" id="StartDate" name="StartDate">
		</div>
	</div>
</div>
<div class="row">
	<div class="col-sm-12">
		<div class="col-sm-offset-1 col-sm-2 ">
			<label for="EndDate">Hasta:</label>
		</div>
		<div class="col-sm-8 ">
			<input type="text" id="EndDate" name="EndDate">
		</div>
	</div>
</div>
<div class="row">
	<div class="col-sm-12">
		<div class="col-sm-offset-1 col-sm-2 ">
			<label for="EndDate">Fecha excepcional:</label>
		</div>
		<div class="col-sm-8 ">
			<input type="checkbox" id="Exception" name="Exception" checked value="true">
		</div>
	</div>
</div>
</div>




<button type="submit" class='btn btn-default'>Confirmar</button>
<button class='btn btn-link' type="button"
	onclick="returnTo('${pageContext.request.contextPath}/servlet/config/employee/EmployeeTurnManager');">Volver</button>
</form>

<%@ include file="/WEB-INF/jsp/common/footer2.jsp"%>
