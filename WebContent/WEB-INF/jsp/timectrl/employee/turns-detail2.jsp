<%@page import="cl.buildersoft.timectrl.business.beans.TurnDay"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Turn"%>
<%@ include file="/WEB-INF/jsp/common/header2.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu2.jsp"%>
<%
	Turn turn = (Turn) request.getAttribute("Turn");
	List<TurnDay> turnDays = (List<TurnDay>) request.getAttribute("TurnDays");
%>

<script
	src="${pageContext.request.contextPath}/js/timectrl/turn/turns-detail.js?<%=BSWeb.randomString()%>">
</script>

<div class="page-header">
	<h1>
		Horarios del turno "<%=turn.getName()%>"
	</h1>
</div>


<div class="row">
	<table id="detailTable"
		class="table table-striped table-bordered table-hover table-condensed table-responsive">
		<thead>
			<tr>
				<th>Día</th>
				<th>Día Habil</th>

				<th align="right">Tolerancia previa<br>Entrada
				</th>
				<th align="center">Hora Inicio
				</th>
				<th>Tolerancia posterior<br>Entrada
				</th>

				<th align="right">Tolerancia previa<br>Salida
				</th>
				<th align="center">Hora término</th>
				<th>Tolerancia posterior<br>Salida
				</th>

				<th>Acciones</th>
			</tr>
		</thead>
		<tbody>

		<%
			Integer size = turnDays.size();
			Integer current = 0;
			String style = null;
			for (TurnDay turnDay : turnDays) {
				current++;
				style = turnDay.getBusinessDay() ? "" : "text-decoration:line-through";
		%>
		<tr>
			<td><%=turnDay.getDay()%></td>
			<td><%=turnDay.getBusinessDay() ? "Si" : "No"%></td>

			<td style='<%=style%>' align="right"><%=turnDay.getEdgePrevIn()%></td>
			<td style='<%=style%>' align="center"><%=turnDay.getStartTime()%></td>
			<td style='<%=style%>'><%=turnDay.getEdgePostIn()%></td>
			<td style='<%=style%>' align="right"><%=turnDay.getEdgePrevOut()%></td>
			<td style='<%=style%>' align="center"><%=turnDay.getEndTime()%></td>
			<td style='<%=style%>'><%=turnDay.getEdgePostOut()%></td>

			<td>
				<button class="btn btn-default"
					onclick="javascript:editTurn(<%=turnDay.getId()%>, <%=current%>)"
					style='display: none'>Editar</button>
				<button class="btn btn-default"
					onclick="deleteTurnDay(<%=turnDay.getId()%>, <%=turnDay.getDay()%>, <%=turn.getId()%>)">Borrar</button>
				<%
					if (current == size) {
				%>
				<button type="button" class="btn btn-default"
					onclick="copyDay(<%=turnDay.getId()%>, <%=turn.getId()%>)">Copiar</button>
				<%
					}
				%>
			</td>
		</tr>
		<%
			}
		%>
		</tbody>
	</table>
</div>
<br>

<button class="btn btn-primary" onclick="addNew(<%=turn.getId()%>);" id="addButton">Nuevo
	Horario</button>
<a class='btn btn-link'
	href="${pageContext.request.contextPath}/servlet/timectrl/turns/TurnManager">Volver</a>

<form id='form' method="post"
	action='${pageContext.request.contextPath}/servlet/timectrl/turns/SaveNewTurn'>
	<input type="hidden" name="Parent" id="Parent"> <input
		type="hidden" name="TurnDay" id="TurnDay"> <input
		type="hidden" name="Day" id="Day"> <input type="hidden"
		name="BusinessDay" id="BusinessDay"> <input type="hidden"
		name="EdgePrevIn" id="EdgePrevIn"> <input type="hidden"
		name="StartTime" id="StartTime"> <input type="hidden"
		name="EdgePostIn" id="EdgePostIn"> <input type="hidden"
		name="EdgePrevOut" id="EdgePrevOut"> <input type="hidden"
		name="EndTime" id="EndTime"> <input type="hidden"
		name="EdgePostOut" id="EdgePostOut">

</form>

<br>

<%@ include file="/WEB-INF/jsp/common/footer2.jsp"%>