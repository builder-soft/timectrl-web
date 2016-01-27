<%@page import="cl.buildersoft.framework.beans.User"%>
<%@page import="cl.buildersoft.timectrl.business.beans.EventType"%>
<%@ include file="/WEB-INF/jsp/common/header2.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu2.jsp"%>
<%
	List<EventType> eventTypeList = (List<EventType>) request.getAttribute("EventTypeList");
	List<User> userList = (List<User>) request.getAttribute("UserList");
%>


<div class="page-header">
	<h1>Visor de eventos</h1>
</div>

<script type="text/javascript">
<!--
	function onLoadPage() {
		$("#DStartDate").datepicker({
			dateFormat : fixDateFormat(dateFormat),
			appendText : " (" + dateFormat.toLowerCase() + ")",
			defaultDate : "-1d",
			changeMonth : true,
			numberOfMonths : 1,
			onSelect : function(selectedDate) {
				$("#DEndDate").datepicker("option", "minDate", selectedDate);
			}
		});
		$("#DEndDate").datepicker({
			dateFormat : fixDateFormat(dateFormat),
			appendText : " (" + dateFormat.toLowerCase() + ")",
			defaultDate : "1d",
			changeMonth : true,
			numberOfMonths : 1,
			onSelect : function(selectedDate) {
				$("#DStartDate").datepicker("option", "maxDate", selectedDate);
			}
		});

	}
//-->
</script>

<form
	action="${pageContext.request.contextPath}/servlet/admin/eventViewer/EventViewerMain?<%=BSWeb.randomString() %>"
	id="QueryForm">

	<div class="well">
		<div class="row ">
			<div class="col-sm-2 ">Fecha inicio:</div>
			<div class="col-sm-4 ">
				<input type="text" id="DStartDate">
			</div>
			<div class="col-sm-2 ">Fecha termino:</div>
			<div class="col-sm-4 ">
				<input type="text" id="DEndDate">
			</div>
		</div>


		<div class="row">
			<div class="col-sm-2 ">Tipo de evento:</div>
			<div class="col-sm-4 ">
				<select>
					<option value="">- Todos -</option>
					<%
						for (EventType eventType : eventTypeList) {
					%>
					<option value="<%=eventType.getId()%>"><%=eventType.getName()%></option>
					<%
						}
					%>
				</select>
			</div>
			<div class="col-sm-2 ">Usuario:</div>
			<div class="col-sm-4 ">
				<select>
					<option value="">- Todos -</option>
					<%
						for (User user : userList) {
					%>
					<option value="<%=user.getId()%>"><%=user.getName()%></option>
					<%
						}
					%>
				</select>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-2 col-sm-offset-10">
				<button class='btn btn-default' onclick="$('#QueryForm').submit()">Buscar</button>
			</div>
		</div>
	</div>
</form>


<!-- 		
Fecha:
<input type="text" id="datepicker">
<br>
<input type="text" name="SomeObject" id="SomeObject"
onfocus="javascript:doubleFocus(this);"
onblur="javascript:doubleBlur(this);"
value="<%=BSWeb.formatDouble(request, 1234.567)%>">
 -->

<table
	class="table table-striped table-bordered table-hover table-condensed table-responsive">
	<thead>
		<tr>
			<th>Fecha</th>
			<th>Hora</th>
			<th>Evento</th>
			<th>Detalle</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>dato</td>
			<td>dato</td>
			<td>dato</td>
			<td>dato</td>
		</tr>
		<tr>
			<td>dato</td>
			<td>dato</td>
			<td>dato</td>
			<td>dato</td>
		</tr>
	</tbody>
</table>


<%@ include file="/WEB-INF/jsp/common/footer2.jsp"%>

