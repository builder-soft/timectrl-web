<%@page import="cl.buildersoft.framework.util.BSConnectionFactory"%>
<%@page import="cl.buildersoft.framework.database.BSmySQL"%>
<%@page import="cl.buildersoft.timectrl.business.beans.LicenseCause"%>
<%@page import="cl.buildersoft.timectrl.business.beans.License"%>
<%@page import="cl.buildersoft.framework.util.BSDateTimeUtil"%>
<%@page import="java.util.List"%>
<%@page import="cl.buildersoft.framework.database.BSBeanUtils"%>
<%@page import="java.sql.Connection"%>

<%@include file="/WEB-INF/jsp/common/header2.jsp"%>
<%@include file="/WEB-INF/jsp/common/menu2.jsp"%>
<%
	List<License> licenses = (List<License>) request.getAttribute("Licenses");
//	List<LicenseCause> causes = (List<LicenseCause>) request.getAttribute("LicenseCause");
	String employeeId = (String) request.getAttribute("cId");
//	String dateFormat =(String)request.getAttribute("DateFormat");
%>

<script type="text/javascript">
<!--
	function addNewLicense(){
//		alert('Nueva licencia');
		document.getElementById("NewLicenseForm").submit();
	}

	function showDialog() {
		showTooltip('divShowDetail');
		//$( "#StartDate" ).datepicker();

		$("#StartDate").datepicker({
			dateFormat : fixDateFormat(dateFormat),
			changeMonth : true,
			numberOfMonths : 1,
			onSelect : function(selectedDate) {
				$("#EndDate").datepicker("option", "minDate", selectedDate);
			}
		});
		$("#EndDate").datepicker({
			dateFormat : fixDateFormat(dateFormat),
			changeMonth : true,
			numberOfMonths : 1,
			onSelect : function(selectedDate) {
				$("#StartDate").datepicker("option", "maxDate", selectedDate);
			}
		});

	}
//-->
</script>
<h1 class="cTitle">Licencias de empleado</h1>

<%@ include file="/WEB-INF/jsp/timectrl/common/employee-info2.jsp"%>

<table class="table table-striped table-bordered table-hover table-condensed table-responsive">
	<thead>
		<tr>
			<th>Fecha Inicio</td>
			<th>Fecha Termino</td>
			<th>Motivo</td>
			<th>Documento</td>
		</tr>
	</thead>
	<tbody>
	<%
		Integer index = 0;
		for (License license : licenses) {
			index++;
	%>
	<tr>
		<td><%=BSDateTimeUtil.date2String(license.getStartDate(), application.getAttribute("DateFormat").toString())%></td>
		<td><%=BSDateTimeUtil.date2String(license.getEndDate(), application.getAttribute("DateFormat").toString())%></td>
		<td><%=getCause(request, license)%></td>
		<td><%=license.getDocument() == null ? "" : license.getDocument()%></td>
	</tr>
	<%
		}
	%>
	<tbody>
</table>

<hr>
<button onclick="javascript:addNewLicense()">Agregar</button>

<a class='btn btn-link'
	href="${applicationScope['DALEA_CONTEXT']}/servlet/config/employee/EmployeeLicenseManager">Volver</a>

<form action="${applicationScope['TIMECTRL_CONTEXT']}/servlet/timectrl/employee/NewLicenseForm" Method="post" id="NewLicenseForm">
	<input type="hidden" name="cId" value="${requestScope.Employee.id}">
</form>

<div id="divShowDetail" style="display: none">
	<h2 class="cTitle2">Detalle de licencia</h2>
	<form
		action="${pageContext.request.contextPath}/servlet/timectrl/employee/SaveNewLicense"
		method="post">

		<input type="hidden" name="cId" value="${requestScope.Employee.id}">
		<table>
			<tr>
				<td class="cLabel">Fecha Inicio:</td>
				<td><input id="StartDate" name="StartDate"></td>
			</tr>
			<tr>
				<td class="cLabel">Fecha Termino:</td>
				<td><input id="EndDate" name="EndDate"></td>
			</tr>
			<tr>
				<td class="cLabel">Motivo:</td>
				<td><select name="Cause">
						<%
//							for (LicenseCause cause : causes) {
						%>
						<option value="< % =cause.getId()%>">< % =cause.getName()%></option>
						<%
//							}
						%>
				</select></td>
			</tr>
			<tr>
				<td class="cLabel">Número de documento:</td>
				<td><input name="Document"></td>
			</tr>
		</table>

		<br />
		<!-- onclick="javascript:closeTooltip()" -->
		<button type="submit">Aceptar</button>
		&nbsp;&nbsp;&nbsp; <a class="cCancel" href="#"
			onclick="javascript:closeTooltip()">Cerrar</a>
	</form>
</div>

<%@ include file="/WEB-INF/jsp/common/footer2.jsp"%>
<%! private String getCause(HttpServletRequest request, License license) {
	BSConnectionFactory cf = new BSConnectionFactory();
	Connection conn = cf.getConnection(request);
	BSmySQL mysql = new BSmySQL();
	String name = mysql.queryField(conn, "SELECT cName FROM tLicenseCause WHERE cId=?", license.getLicenseCause());
	cf.closeConnection(conn);
	return name;
	}%>
