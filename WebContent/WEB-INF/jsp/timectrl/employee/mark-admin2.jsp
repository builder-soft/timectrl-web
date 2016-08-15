<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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


<h1 class="cTitle">Administración de marcas</h1>

<c:import url="/servlet/dalea/web/GetEmployeeInfo" />


<form id="SearchForm"
	action="${pageContext.request.contextPath }/servlet/timectrl/employee/MarkAdmin"
	method="post">
	<input type="hidden" name="cId" value="${requestScope.cId}">

	<div class="row well">
		<div class="row">
			<div class="col-sm-3 ">Rango desde
				&nbsp;:&nbsp;&nbsp;${requestScope.StartDate}</div>
			<div class="col-sm-2 ">
				Hasta&nbsp;:&nbsp;&nbsp;<input type="text" name="Today" id="Today"
					size="10" readonly>
			</div>
			<div class="col-sm-4 ">
				<button type="submit">Buscar</button>
				&nbsp;&nbsp;
				<button type="submit" onclick="javascript:resetDate()">Hoy</button>
			</div>
			<div class="col-sm-6 ">&nbsp;</div>
		</div>
	</div>

</form>

<div id="top-menu">
	<ul class="nav menu nav-pills topmenu">
		<li class="item-109"><a
			href="${pageContext.request.contextPath }/servlet/timectrl/employee/MarkAdmin?cId=${requestScope.cId}&Today=${requestScope.StartRange}"
			class="cLink">${requestScope.Range} días antes</a></li>
		<li class="item-138"><a
			href="${pageContext.request.contextPath }/servlet/timectrl/employee/MarkAdmin?cId=${requestScope.cId}&Today=${requestScope.OneDayBefore}"
			class="cLink">1 día antes</a></li>
		<li class="item-110"><a
			href="${pageContext.request.contextPath }/servlet/timectrl/employee/MarkAdmin?cId=${requestScope.cId}&Today=${requestScope.OneDayAfter}"
			class="cLink">1 día después</a></li>
		<li class="item-120"><a
			href="${pageContext.request.contextPath }/servlet/timectrl/employee/MarkAdmin?cId=${requestScope.cId}&Today=${requestScope.EndRange}"
			class="cLink">${requestScope.Range} días después</a></li>
	</ul>
</div>


<br>
<br>
<form id="SearchForm"
	action="${pageContext.request.contextPath }/servlet/timectrl/employee/MarkNewUpdate"
	method="post">

	<input type="hidden" name="cId" value="${requestScope.cId}"> <input
		type="hidden" name="Today" value="${requestScope.EndDate}">

	<table
		class="table table-striped table-bordered table-hover table-condensed table-responsive">
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
	<button class='btn btn-default'>Agregar
		Marca</button>&nbsp;
	<button class='btn' disabled>Modificar
		Marca (agrega y deshabilita)</button>
	&nbsp;&nbsp; <a class='btn btn-link'
		href="${pageContext.request.contextPath}/servlet/config/employee/EmployeeMarkManager">Volver</a>
</form>

<%@ include file="/WEB-INF/jsp/common/footer2.jsp"%>


<%!
	private String boldIfNew(Boolean isNew, Object value) {
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
	}
	
%>