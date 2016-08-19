<%@page import="java.util.Calendar"%>
<%@page import="cl.buildersoft.framework.util.BSDateTimeUtil"%>
<%@page import="cl.buildersoft.timectrl.business.beans.AttendanceLog"%>
<%@page import="java.util.ArrayList"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Machine"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Employee"%>
<%@page
	import="cl.buildersoft.timectrl.business.services.impl.EmployeeServiceImpl"%>
<%@page
	import="cl.buildersoft.timectrl.business.services.EmployeeService"%>

<%@ include file="/WEB-INF/jsp/common/header2.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu2.jsp"%>
<%
	Object attendanceObject = request.getAttribute("Attendances");
	String dateTimeFormat = (String) request.getAttribute("DateTimeFormat");
	List<AttendanceLog> attendanceList = null;
	if (attendanceObject != null) {
		attendanceList = (List<AttendanceLog>) attendanceObject;
	} else {
		attendanceList = new ArrayList<AttendanceLog>();
	}
	Machine machine = (Machine) request.getAttribute("Machine");
%>

<script
	src="${pageContext.request.contextPath}/js/timectrl/machine/read-attendance2.js">
	
</script>

<div class="page-header">
	<h1>Asistencias leida desde dispositivo</h1>
</div>
<table
	class="table table-striped table-bordered table-hover table-condensed table-responsive">
	<thead>
		<tr>
			<th>No</th>
			<th>Id Empleado</th>
			<th>Empleado</th>
			<th>Fecha Hora</th>
			<th>Tipo de marca</th>
			<th>Máquina</th>
		</tr>
	</thead>
	<tbody>
		<%
			if (attendanceObject != null) {
				Integer no = 0;
				for (AttendanceLog attendance : attendanceList) {
					no++;
		%>
		<tr>
			<td><%=no%></td>
			<td><%=attendance.getEmployeeKey()%></td>
			<td><%=getEmployeeName(request, attendance.getEmployeeKey())%></td>
			<td><%=dataToDate(attendance, dateTimeFormat)%></td>
			<td><%=attendance.getMarkType()%></td>
			<td><%=machine.getName()%></td>
		</tr>
		<%
			}
			} else {
		%>
		<tr>
			<td colspan="5">No hay información en este momento</td>
		</tr>
		<%
			}
		%>
	</tbody>
</table>
<br>

<form id="SaveAttendanceForm"
	action="${pageContext.request.contextPath}/servlet/timectrl/machine/SaveAttendanceToDataBase"
	method="post">
	<input type="hidden" value="<%=machine.getId()%>" name="Machine">
	<input type="hidden" name="DeleteFromDevice" ID="DeleteFromDevice">
</form>
<%
	if (attendanceObject != null) {
%>
<button class="btn btn-primary" onclick="javascript:saveToDatabase()">Grabar en base de
	datos</button>
<input type="checkbox" checked id="DDeleteFromDevice">
<label for="DDeleteFromDevice">Borrar información del reloj</label>
&nbsp;&nbsp;&nbsp;
<%
	}
%>

<button class='btn btn-link'
	onclick="returnTo('${pageContext.request.contextPath}/servlet/timectrl/machine/MachineManager');">Volver</button>




<%@ include file="/WEB-INF/jsp/common/footer2.jsp"%>

<%!private String getEmployeeName(HttpServletRequest request, String key) {
		EmployeeService employeeService = new EmployeeServiceImpl();
		Employee employee = employeeService.getEmployeeByKey(request, key);

		return employee.getName();
	}

	private String dataToDate(AttendanceLog attendanceLog, String dateTimeFormat) {
		Calendar calendar = Calendar.getInstance();
		calendar.set(Calendar.YEAR, attendanceLog.getYear());
		calendar.set(Calendar.MONTH, attendanceLog.getMonth() - 1);
		calendar.set(Calendar.DATE, attendanceLog.getDay());
		calendar.set(Calendar.HOUR, attendanceLog.getHour());
		calendar.set(Calendar.MINUTE, attendanceLog.getMinute());
		calendar.set(Calendar.SECOND, attendanceLog.getSecond());

		return BSDateTimeUtil.calendar2String(calendar, dateTimeFormat);
	}%>
