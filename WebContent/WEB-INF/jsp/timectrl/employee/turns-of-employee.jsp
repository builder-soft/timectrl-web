<%@page import="cl.buildersoft.timectrl.business.beans.Employee"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Turn"%>
<%@page import="cl.buildersoft.framework.util.BSDateTimeUtil"%>
<%@page import="cl.buildersoft.timectrl.business.beans.EmployeeTurn"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Post"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Area"%>
<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>
<%
	Employee employee = (Employee) request.getAttribute("Employee");
	/**
	 Post post = (Post) request.getAttribute("Post");
	 Area area = (Area) request.getAttribute("Area");
	 */
	List<EmployeeTurn> employeeTurns = (List<EmployeeTurn>) request.getAttribute("EmployeeTurn");
	String dateFormat = (String) request.getAttribute("DateFormat");
	List<Turn> turns = (List<Turn>) request.getAttribute("Turns");
%>
<script type="text/javascript">//	var dateFormat = "<%=dateFormat%>";
</script>

<script
	src="${pageContext.request.contextPath}/js/timectrl/turn/turns-of-employee.js?<%=BSWeb.randomString()%>">
</script>
<h1 class="cTitle">Configuración de turnos</h1>

<%@ include file="/WEB-INF/jsp/timectrl/common/employee-info.jsp"%>

<hr>

<table class="cList" cellpadding="0" cellspacing="0" id="detailTable">
	<tr>
		<td class='cHeadTD'>Turno</td>
		<td class='cHeadTD'>Desde</td>
		<td class='cHeadTD'>Hasta</td>
		<td class='cHeadTD'>Acción</td>
	</tr>
	<%
		for (EmployeeTurn employeeTurn : employeeTurns) {
	%>
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
</table>
<br>

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

<button onclick="addNew(<%=employee.getId()%>);" id="addButton">Agregar
	Turno</button>

<a class="cCancel"
	href="${pageContext.request.contextPath}/servlet/config/employee/EmployeeManager">Volver</a>

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
</form>


<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>

