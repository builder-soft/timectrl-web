<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Machine"%>
<%@page import="cl.buildersoft.timectrl.business.beans.MarkType"%>
<%@page import="cl.buildersoft.framework.util.BSDateTimeUtil"%>
<%@page import="java.sql.ResultSet"%>
<%@ include file="/WEB-INF/jsp/common/header2.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu2.jsp"%>
<%
	List<Object[]> matrix = (List<Object[]>) request.getAttribute("Matrix");
	List<Machine> machines = (List<Machine>) request.getAttribute("Machines");
	List<MarkType> markTypes = (List<MarkType>) request.getAttribute("MarkTypes");
	//Integer range = (Integer) request.getAttribute("Range");
%>
<script>
	var today = '${requestScope.EndDate}';
	var currentDay = '${requestScope.Today}';
</script>
<script
	src="${pageContext.request.contextPath}/js/timectrl/employee/mark-admin.js">
	
</script>
<style type="text/css">
.topmenu .active a, .topmenu .active a:hover {
	background-color: white;
}

.topmenu>li>a {
	color: Gray;
	font-weight: bold;
}

.topmenu>li>a:hover {
	color: black;
	background: white;
}
</style>

<h1 class="cTitle2">Nueva marca</h1>

<c:import url="/servlet/dalea/web/GetEmployeeInfo" />
<!-- 
	< % @ include file="/WEB-INF/jsp/timectrl/common/employee-info.jsp"%>
	-->
<br>
<br>
<form id="SaveForm"
	action="${pageContext.request.contextPath}/servlet/config/employee/SaveNewMark">
	<input type="hidden" name="Employee" value="${requestScope.cId}">
	<input type="hidden" name="Today" value="${requestScope.today}">

	<table
		class="table table-striped table-bordered table-hover table-condensed table-responsive">
		<tr>
			<td class="cLabel">Reloj:</td>
			<td><select Name="Machine">
					<%
						for (Machine machine : machines) {
					%>
					<option value="<%=machine.getId()%>"><%=machine.getName()%></option>
					<%
						}
					%>
			</select></td>
		</tr>
		<tr>
			<td class="cLabel">Fecha/Hora</td>
			<td class="cLabel"><input type="text" id="DateMark" name="DateMark" size="10" readonly> <select
				id="HH">
					<%=options(0, 23, 9)%>
			</select>: <select id="MM">
					<%=options(0, 59, 0)%>
			</select>: <select id="SS">
					<%=options(0, 59, 0)%>
			</select> <input name="DateTimeMark" id="DateTimeMark" type="hidden">
				<!-- 
							<input name="DateTimeMark"
								placeholder="${DateTimeFormat}"
								onblur="javascript:dateTimeBlur(this);">
								 --></td>
		</tr>
		<tr>
			<td class="cLabel">Tipo de marca</td>
			<td><select name="MarkType">
					<%
						for (MarkType markType : markTypes) {
					%>
					<option value="<%=markType.getId()%>"><%=markType.getName()%></option>
					<%
						}
					%>
			</select></td>
		</tr>
	</table>
	<br> <br>
	<button type="button" onclick="javascript:saveNewMark()" class='btn btn-default'>Aceptar</button>
<!-- 	<button type="button" onclick="javascript:closeTooltip()" class='btn' >Cancelar</button> -->
	<a class="btn btn-link" role="button"href="javascript:history.back()">Volver</a>
</form>


<%@ include file="/WEB-INF/jsp/common/footer2.jsp"%>


<%!

	private String options(Integer start, Integer end, Integer def) {
		String out = "";
		String s = "";
		for (int i = start; i <= end; i++) {
			s = (i < 10 ? "0" : "") + i;
			out += "<option " + (i == def ? "selected" : "") + " value='" + s + "' >" + s + "</option>";
		}
		return out;
	}
%>