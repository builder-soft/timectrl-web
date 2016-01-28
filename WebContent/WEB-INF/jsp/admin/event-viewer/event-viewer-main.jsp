<%@page import="cl.buildersoft.framework.util.BSDateTimeUtil"%>
<%@page import="cl.buildersoft.timectrl.business.beans.EventBean"%>
<%@page import="cl.buildersoft.framework.beans.User"%>
<%@page import="cl.buildersoft.timectrl.business.beans.EventType"%>
<%@ include file="/WEB-INF/jsp/common/header2.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu2.jsp"%>
<%
	List<EventType> eventTypeList = (List<EventType>) request.getAttribute("EventTypeList");
	List<User> userList = (List<User>) request.getAttribute("UserList");
	List<EventBean> eventList = (List<EventBean>)request.getAttribute("EventList");
	
	String dateFormat = BSDateTimeUtil.getFormatDatetime(request);
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

<form method="post"
	xaction="${pageContext.request.contextPath}/servlet/ShowParameters"
	action="${pageContext.request.contextPath}/servlet/admin/eventViewer/EventViewerMain?<%=BSWeb.randomString() %>"
	id="QueryForm">

	<div class="well">
		<div class="row ">
			<div class="col-sm-2 ">Fecha inicio:</div>
			<div class="col-sm-4 ">
				<input type="text" id="DStartDate" Name="StartDate">
			</div>
			<div class="col-sm-2 ">Fecha termino:</div>
			<div class="col-sm-4 ">
				<input type="text" id="DEndDate" Name="EndDate">
			</div>
		</div>


		<div class="row">
			<div class="col-sm-2 ">Tipo de evento:</div>
			<div class="col-sm-4 ">
				<select Name="EventType">
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
				<select Name="User">
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
	<caption><%=eventList != null ? eventList.size() : "Nothing to show"%></caption>
	<thead>
		<tr>
			<th>Fecha</th>
			<th>Usuario</th>
			<th>Evento</th>
			<th>Detalle</th>
		</tr>
	</thead>
	<tbody>
		<%
			if (eventList != null) {
				for (EventBean event : eventList) {
		%>
		<tr>
			<td><%=BSDateTimeUtil.calendar2String(event.getWhen(), dateFormat)%></td>
			<td><%=event.getUserName()%> (<%=event.getUserMail()%>)</td>
			<td><%=event.getEventTypeName()%></td>
			<td><%=event.getWhat()%></td>
		</tr>
		<%
			}
			}
		%>
		
	</tbody>
</table>


<%@ include file="/WEB-INF/jsp/common/footer2.jsp"%>

