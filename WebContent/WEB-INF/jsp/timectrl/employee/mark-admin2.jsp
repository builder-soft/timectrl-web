<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="cl.buildersoft.timectrl.business.beans.Machine"%>
<%@page import="cl.buildersoft.timectrl.business.beans.MarkType"%>
<%@page import="cl.buildersoft.framework.util.BSDateTimeUtil"%>
<%@page import="java.sql.ResultSet"%>
<%@ include file="/WEB-INF/jsp/common/header2.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu2.jsp"%>
<%
	List<Object[]> matrix = (List<Object[]>) request.getAttribute("Matrix");
	String dateTimeFormat = (String) request.getAttribute("DateTimeFormat");
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

<h1 class="cTitle">Administración de marcas</h1>

<c:import url="/servlet/dalea/web/GetEmployeeInfo" />
<!-- 
< % @ include file="/WEB-INF/jsp/timectrl/common/employee-info.jsp"%>
-->

<form id="SearchForm"
	action="${pageContext.request.contextPath }/servlet/timectrl/employee/MarkAdmin"
	method="post">
	<input type="hidden" name="cId" value="${requestScope.cId}">
	<table border="0">
		<tr>
			<td class="cLabel">Rango desde:</td>
			<td class="cData">${requestScope.StartDate}</td>
			<td class="cLabel">Hasta:</td>
			<td><input type="text" name="Today" id="Today" size="10">
				<!-- 
			<input type="text" name="Today" id="Today"
				placeholder="${requestScope.DateFormat}"
				value="${requestScope.EndDate}">
				 --></td>
			<td>
				<button type="submit">Buscar</button>
			</td>
			<td><button type="submit" onclick="javascript:resetDate()">Hoy</button></td>
	</table>
</form>

<a
	href="${pageContext.request.contextPath }/servlet/timectrl/employee/MarkAdmin?cId=${requestScope.cId}&Today=${requestScope.StartRange}"
	class="cLink">${requestScope.Range} días antes</a>
&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
<a
	href="${pageContext.request.contextPath }/servlet/timectrl/employee/MarkAdmin?cId=${requestScope.cId}&Today=${requestScope.OneDayBefore}"
	class="cLink">1 día antes</a>
&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
<a
	href="${pageContext.request.contextPath }/servlet/timectrl/employee/MarkAdmin?cId=${requestScope.cId}&Today=${requestScope.OneDayAfter}"
	class="cLink">1 día después</a>
&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
<a
	href="${pageContext.request.contextPath }/servlet/timectrl/employee/MarkAdmin?cId=${requestScope.cId}&Today=${requestScope.EndRange}"
	class="cLink">${requestScope.Range} días después</a>

<br>
<br>
<table class="cList" cellpadding="0" cellspacing="0">
	<tr>
		<td class='cHeadTD' style="text-align: center">Sel.</td>
		<td class='cHeadTD'>Reloj</td>
		<td class='cHeadTD'>Fecha/Hora Marca</td>
		<td class='cHeadTD'>Día</td>
		<td class='cHeadTD'>Tipo de Marca</td>
		<td class='cHeadTD'>Comentario</td>
	</tr>

	<%
		String style = "";
		Integer i = 0;
		Boolean isNew = false;
		for (Object[] row : matrix) {
			i++;
			style = i % 2 == 0 ? "cDataTD" : "cDataTD_odd";
			isNew = row[7].equals("N");
	%>
	<tr>
		<td class='<%=style%>' style="text-align: center"><input
			type="radio" name="MarkId" onclick="selectingMark(this)"
			value="<%=row[0]%>">
		<td class='<%=style%>'><%=boldIfNew(isNew, row[2])%></td>
		<td class='<%=style%>'><%=boldIfNew(isNew, BSDateTimeUtil.date2String(row[3], dateTimeFormat))%></td>
		<td class='<%=style%>'><%=boldIfNew(isNew, row[4])%></td>
		<td class='<%=style%>'><%=boldIfNew(isNew, row[6])%></td>
		<td class='<%=style%>'><%=boldIfNew(isNew, isNew ? "Nuevo" : "")%></td>
	</tr>
	<%
		}
	%>

</table>

<hr>

<button onclick="javascript:showDialog();">Agregar Marca</button>
<button onclick="javascript:showDialog();" disabled>Modificar Marca (agrega y deshabilita)</button>
<!-- 
<button onclick="javascript:editMark('divShowDetail');" disabled id="modifyButton">Modificar
	Marca</button>
<button disabled="true">Eliminar Marca</button>
 -->
&nbsp;&nbsp;&nbsp;
<a class="cCancel"
	href="${pageContext.request.contextPath}/servlet/config/employee/EmployeeMarkManager">Volver</a>

<div id="divShowDetail" style="display: none">
	<h2 class="cTitle2">Nueva marca</h2>

	<c:import url="/servlet/dalea/web/GetEmployeeInfo" />
	<!-- 
	< % @ include file="/WEB-INF/jsp/timectrl/common/employee-info.jsp"%>
	-->
	<br> <br>
	<form id="SaveForm"
		action="${pageContext.request.contextPath}/servlet/config/employee/SaveNewMark">
		<input type="hidden" name="Employee" value="${requestScope.cId}">
		<input type="hidden" name="Today" value="${requestScope.EndDate}">

		<table border="0" width="80%">
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
				<td class="cLabel"><input id="DateMark" size="10"> <select
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
		<button type="button" onclick="javascript:saveNewMark()">Aceptar</button>
		<button onclick="javascript:closeTooltip()" type="button">Cancelar</button>
	</form>


</div>
<%@ include file="/WEB-INF/jsp/common/footer2.jsp"%>


<%!private String boldIfNew(Boolean isNew, Object value) {
		return isNew ? "<b>" + value.toString() + "</b>" : value.toString();
	}

	private String options(Integer start, Integer end, Integer def) {
		String out = "";
		String s = "";
		for (int i = start; i <= end; i++) {
			s = (i < 10 ? "0" : "") + i;
			out += "<option " + (i == def ? "selected" : "") + " value='" + s + "' >" + s + "</option>";
		}
		return out;
	}%>