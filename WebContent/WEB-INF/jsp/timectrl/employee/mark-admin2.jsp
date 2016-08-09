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
<style type="text/css">

.topmenu .active a,
.topmenu .active a:hover {
    background-color: white;
}
.topmenu > li > a{
    color: Gray;
    font-weight:bold;
}
.topmenu > li > a:hover {
    color: black;
    background:white;
} 

</style>


<h1 class="cTitle">Administración de marcas</h1>

<c:import url="/servlet/dalea/web/GetEmployeeInfo" />
<!-- 
< % @ include file="/WEB-INF/jsp/timectrl/common/employee-info.jsp"%>
-->

<form id="SearchForm"
	action="${pageContext.request.contextPath }/servlet/timectrl/employee/MarkAdmin"
	method="post">
	<input type="hidden" name="cId" value="${requestScope.cId}">
<%-- 	<table border="0" class="table table-striped table-bordered table-hover table-condensed table-responsive" >
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
	</table> --%>
	<div class="row well">
		<div class="row">
			<div class="col-sm-3 ">Rango desde &nbsp;:&nbsp;&nbsp;${requestScope.StartDate}</div>
			<div class="col-sm-2 ">Hasta&nbsp;:&nbsp;&nbsp;<input type="text" name="Today" id="Today" size="10" readonly></div>
			<div class="col-sm-4 "><button type="submit">Buscar</button>&nbsp;&nbsp;<button type="submit" onclick="javascript:resetDate()">Hoy</button></div>
			<div class="col-sm-6 ">&nbsp;</div>
		</div>
	</div>		
	
</form>

<%-- <a
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
	class="cLink">${requestScope.Range} días después</a> --%>

<div id="top-menu">
	<ul class="nav menu nav-pills topmenu">
		<li class="item-109"><a href="${pageContext.request.contextPath }/servlet/timectrl/employee/MarkAdmin?cId=${requestScope.cId}&Today=${requestScope.StartRange}"
			class="cLink">${requestScope.Range} días antes</a></li>
		<li class="item-138"><a href="${pageContext.request.contextPath }/servlet/timectrl/employee/MarkAdmin?cId=${requestScope.cId}&Today=${requestScope.OneDayBefore}"
		class="cLink">1 día antes</a></li>
		<li class="item-110"><a href="${pageContext.request.contextPath }/servlet/timectrl/employee/MarkAdmin?cId=${requestScope.cId}&Today=${requestScope.OneDayAfter}"
		class="cLink">1 día después</a></li>
		<li class="item-120"><a href="${pageContext.request.contextPath }/servlet/timectrl/employee/MarkAdmin?cId=${requestScope.cId}&Today=${requestScope.EndRange}"
		class="cLink">${requestScope.Range} días después</a></li>
	</ul>
</div>


<br>
<br>
<table class="table table-striped table-bordered table-hover table-condensed table-responsive">
  <thead>		
	<tr>
		<th class='cHeadTD' style="text-align: center">Sel.</th>
		<th class='cHeadTD'>Reloj</th>
		<th class='cHeadTD'>Fecha/Hora Marca</th>
		<th class='cHeadTD'>Día</th>
		<th class='cHeadTD'>Tipo de Marca</th>
		<th class='cHeadTD'>Comentario</th>
	</tr>
  </thead>
	<%
		String style = "";
		Integer i = 0;
		Boolean isNew = false;
		for (Object[] row : matrix) {
			i++;
			style = i % 2 == 0 ? "cDataTD" : "cDataTD_odd";
			isNew = row[7].equals("N");
	%>
   <tbody>
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
  </tbody>		
	<%
		}
	%>

</table>

<hr>

<button onclick="javascript:showDialog();" class='btn btn-default'>Agregar Marca</button>
<button onclick="javascript:showDialog();" class='btn' disabled>Modificar Marca (agrega y deshabilita)</button>
<!-- 
<button onclick="javascript:editMark('divShowDetail');" disabled id="modifyButton">Modificar
	Marca</button>
<button disabled="true">Eliminar Marca</button>
 -->
&nbsp;&nbsp;&nbsp;
<a class='btn btn-link'
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

		<table class="table table-striped table-bordered table-hover table-condensed table-responsive">
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