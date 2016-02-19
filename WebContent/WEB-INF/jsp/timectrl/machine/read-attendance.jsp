<%@page import="java.util.Calendar"%>
<%@page import="cl.buildersoft.framework.util.BSDateTimeUtil"%>
<%@page import="cl.buildersoft.timectrl.business.beans.AttendanceLog"%>
<%@page import="java.util.ArrayList"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Machine"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Employee"%>
<%@page
	import="cl.buildersoft.timectrl.business.services.impl.EmployeeServiceImpl"%>
<%@page import="cl.buildersoft.timectrl.business.services.EmployeeService"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>
<%
	Object attendanceObject =  request.getAttribute("Attendances");
	String dateTimeFormat=(String)request.getAttribute("DateTimeFormat");
	List<AttendanceLog> attendanceList = null;
	if(attendanceObject!=null){
		attendanceList = (List<AttendanceLog>) attendanceObject;
	}else{
		attendanceList = new ArrayList<AttendanceLog>();
	}
	Machine  machine =(Machine) request.getAttribute("Machine");
%>

<script
	src="${pageContext.request.contextPath}/js/timectrl/machine/read-attendance.js">
	
</script>

<h1 class="cTitle">Lista de asistencias leidas desde dispositivo</h1>

<table class="cList" cellpadding="0" cellspacing="0">
	<tr>
		<td class='cHeadTD'>No</td>
		<td class='cHeadTD'>Id Empleado</td>
		<td class='cHeadTD'>Empleado</td>
		<td class='cHeadTD'>Fecha Hora</td>
		<td class='cHeadTD'>Tipo de marca</td>
		<td class='cHeadTD'>Máquina</td>
	</tr>

	<%
		if (attendanceObject != null) {
			Integer no = 0;
			for (AttendanceLog attendance : attendanceList) {
				no++;
	%>
	<tr>
		<td class='cDataTD'><%=no%></td>
		<td class='cDataTD'><%=attendance.getEmployeeKey()%></td>
		<td class='cDataTD'><%=getEmployeeName(request, attendance.getEmployeeKey())%></td>
		<td class='cDataTD'><%=dataToDate(attendance, dateTimeFormat)%></td>
		<td class='cDataTD'><%=attendance.getMarkType()%></td>
		<td class='cDataTD'><%=machine.getName()%></td>
	</tr>
	<%
			}
		} else {
	%>
	<tr>
		<td class='cDataTD' colspan="5">No hay información en este
			momento</td>
	</tr>
	<%
		}
	%>

</table>
<br>

<form
	action="${pageContext.request.contextPath}/servlet/timectrl/machine/SaveAttendanceToDataBase"
	method="post">
	<%
		if (attendanceObject != null) {
	%>
	<button onclick="javascript:saveToDatabase()">Grabar en base
		de datos</button>
	<input type="checkbox" checked name="DeleteFromDevice"><span
		class="cLabel">Borrar información del reloj</span><input type="hidden"
		value="<%=machine.getId()%>" name="Machine">
	&nbsp;&nbsp;&nbsp;
	<%
		}
	%>
	<a class="cCancel"
		href="${pageContext.request.contextPath}/servlet/timectrl/machine/MachineManager">Volver</a>
</form>



<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>

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
