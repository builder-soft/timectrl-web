<%@page import="cl.buildersoft.timectrl.business.beans.TurnDay"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Turn"%>
<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>
<%
	Turn turn = (Turn) request.getAttribute("Turn");
	List<TurnDay> turnDays= (List<TurnDay>)request.getAttribute("TurnDays");
%>

<script
	src="${pageContext.request.contextPath}/js/timectrl/turn/turns-detail.js?<%=BSWeb.randomString()%>">
	
</script>


<h1 class="cTitle">
	Horarios del turno "<%=turn.getName()%>"
</h1>

<table class="cList" cellpadding="0" cellspacing="0" id="detailTable">
	<tr>
		<td class='cHeadTD'>Día</td>
		<td class='cHeadTD'>Día Habil</td>

		<td class='cHeadTD' align="right">Tolerancia previa<br>Entrada
		</td>
		<td class='cHeadTD' align="center">Hora Inicio</td>
		<td class='cHeadTD'>Tolerancia posterior<br>Entrada
		</td>

		<td class='cHeadTD' align="right">Tolerancia previa<br>Salida
		</td>
		<td class='cHeadTD' align="center">Hora término</td>
		<td class='cHeadTD'>Tolerancia posterior<br>Salida
		</td>

		<td class='cHeadTD'>Acciones</td>
	</tr>

	<%
		Integer size = turnDays.size();
		Integer current = 0;
		String style = null;
		for (TurnDay turnDay : turnDays) {
			current++;
			style = turnDay.getBusinessDay() ? "" : "text-decoration:line-through";
	%>
	<tr>
		<td class='cDataTD'><%=turnDay.getDay()%></td>
		<td class='cDataTD'><%=turnDay.getBusinessDay() ? "Si" : "No"%></td>

		<td class='cDataTD' style='<%=style%>' align="right"><%=turnDay.getEdgePrevIn()%></td>
		<td class='cDataTD' style='<%=style%>' align="center"><%=turnDay.getStartTime()%></td>
		<td class='cDataTD' style='<%=style%>'><%=turnDay.getEdgePostIn()%></td>
		<td class='cDataTD' style='<%=style%>' align="right"><%=turnDay.getEdgePrevOut()%></td>
		<td class='cDataTD' style='<%=style%>' align="center"><%=turnDay.getEndTime()%></td>
		<td class='cDataTD' style='<%=style%>'><%=turnDay.getEdgePostOut()%></td>

		<td class='cDataTD'>
		<button onclick="javascript:editTurn(<%=turnDay.getId() %>, <%=current%>)" style='display:none'>Editar</button>
		<button
				onclick="deleteTurnDay(<%=turnDay.getId()%>, <%=turnDay.getDay()%>, <%=turn.getId()%>)">Borrar</button>
			<%
				if (current == size) {
			%>
			<button type="button" onclick="copyDay(<%=turnDay.getId()%>, <%=turn.getId()%>)">Copiar</button>
			<%
				}
			%></td>
	</tr>
	<%
		}
	%>
</table>
<br>

<button onclick="addNew(<%=turn.getId()%>);" id="addButton">Nuevo
	Horario</button>
<a class="cCancel"
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

 

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>

