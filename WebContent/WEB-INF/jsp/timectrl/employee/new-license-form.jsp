<%@page import="cl.buildersoft.framework.util.BSDateTimeUtil"%>
<%@page import="java.util.Calendar"%>
<%@page import="cl.buildersoft.timectrl.business.beans.LicenseCause"%>
<%@ include file="/WEB-INF/jsp/common/header2.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu2.jsp"%>
<%
	List<LicenseCause> causes = (List<LicenseCause>) request.getAttribute("LicenseCause");

	Calendar startDate = null; // (Calendar) request.getAttribute("StartDate");
	Calendar endDate = null; // (Calendar) request.getAttribute("EndDate");

	if (startDate == null) {
		startDate = Calendar.getInstance();
	}
	if (endDate == null) {
		endDate = Calendar.getInstance();
	}

	String dateFormat = request.getServletContext().getAttribute("DateFormat").toString();
%>
<div class="page-header">
	<h1>Formulario para incorporar nueva licencia</h1>
</div>

<script type="text/javascript">
<!--
function selectDateAtStart(selectedDate){
	$("#EndDate").datepicker("option", "minDate", selectedDate);
}

function selectDateAtEnd(selectedDate){
	$("#StartDate").datepicker("option", "maxDate", selectedDate);
}

function onLoadPage() {
	$("#StartDate").datepicker({
		dateFormat : fixDateFormat(dateFormat),
		appendText : " (" + dateFormat.toLowerCase() + ")",
		changeMonth : true,
		numberOfMonths : 1,
		onSelect : selectDateAtStart
	});
	
	$("#EndDate").datepicker({
		dateFormat : fixDateFormat(dateFormat),
		appendText : " (" + dateFormat.toLowerCase() + ")",
		defaultDate : "1d",
		changeMonth : true,
		numberOfMonths : 1,
		onSelect : selectDateAtEnd
	});

	$("#StartDate").datepicker("setDate", "<%=BSDateTimeUtil.calendar2String(startDate, dateFormat)%>");
	$("#EndDate").datepicker("setDate", "<%=BSDateTimeUtil.calendar2String(endDate, dateFormat)%>");
	selectDateAtStart("<%=BSDateTimeUtil.calendar2String(startDate, dateFormat)%>");
	selectDateAtEnd("<%=BSDateTimeUtil.calendar2String(endDate, dateFormat)%>");
}

function send(){
	document.getElementById('SaveForm').submit();
	
}
//-->
</script>

<%@ include file="/WEB-INF/jsp/timectrl/common/employee-info2_.jsp"%>


<!-- 
<div class="row">
	<div class="col-sm-12 well">dato</div>
	<input type="hidden" name="cId" value="${requestScope.Employee.id}">
</div>
-->
<form class="form-horizontal" role="form" id="SaveForm"
	action="${applicationScope['TIMECTRL_CONTEXT']}/servlet/timectrl/employee/SaveNewLicense">
	<input type="hidden" name="cId" value="${requestScope.Employee.id}">
	<div class="row well">
		<div class="row">
			<div class="col-sm-2">Fecha inicio:</div>
			<div class="col-sm-4">
				<input type="text" id="StartDate" name="StartDate">
			</div>

			<div class="col-sm-2">Fecha termino:</div>
			<div class="col-sm-4">
				<input type="text" id="EndDate" name="EndDate">
			</div>
		</div>
		<div class="row">
			<div class="col-sm-2 ">Motivo:</div>
			<div class="col-sm-4 ">
				<select name="Cause">
					<%
						for (LicenseCause cause : causes) {
					%>
					<option value="<%=cause.getId()%>"><%=cause.getName()%></option>
					<%
						}
					%>
				</select>
			</div>

			<div class="col-sm-2 ">Número de documento:</div>
			<div class="col-sm-4 ">
				<input name="Document">
			</div>
		</div>
	</div>
</form>
<button onclick='javascript:send();'>Aceptar</button>
<button class='btn btn-link'
	onclick="javascript:returnTo('${applicationScope['TIMECTRL_CONTEXT']}/servlet/timectrl/employee/LicenseOfEmployee?CodeAction=LICENSE&cId=${requestScope.Employee.id}');">Cancelar</button>

<%@ include file="/WEB-INF/jsp/common/footer2.jsp"%>
