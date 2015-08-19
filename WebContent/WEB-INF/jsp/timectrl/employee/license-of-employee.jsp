<%@page import="cl.buildersoft.framework.database.BSmySQL"%>
<%@page import="cl.buildersoft.timectrl.business.beans.LicenseCause"%>
<%@page import="cl.buildersoft.timectrl.business.beans.License"%>
<%@page import="cl.buildersoft.framework.util.BSDateTimeUtil"%>
<%@page import="java.util.List"%>
<%@page import="cl.buildersoft.framework.database.BSBeanUtils"%>
<%@page import="java.sql.Connection"%>

<%@include file="/WEB-INF/jsp/common/header.jsp"%>
<%@include file="/WEB-INF/jsp/common/menu.jsp"%>
<%
	List<License> licenses = (List<License>) request.getAttribute("Licenses");
	List<LicenseCause> causes = (List<LicenseCause>) request.getAttribute("LicenseCause");
	String employeeId = (String) request.getAttribute("cId");
	String dateFormat =(String)request.getAttribute("DateFormat");
%>

<script type="text/javascript">
<!--
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

<%@ include file="/WEB-INF/jsp/timectrl/common/employee-info.jsp"%>

<table class="cList" cellpadding="0" cellspacing="0">
	<tr>
		<td class='cHeadTD'>Fecha Inicio</td>
		<td class='cHeadTD'>Fecha Termino</td>
		<td class='cHeadTD'>Motivo</td>
		<td class='cHeadTD'>Documento</td>
	</tr>
	<%
		Integer index = 0;
		for (License license : licenses) {
			index++;
	%>
	<tr>
		<td class='<%=index % 2 == 0 ? "cDataTD" : "cDataTD_odd"%>'><%=BSDateTimeUtil.date2String(license.getStartDate(), dateFormat)%></td>
		<td class='<%=index % 2 == 0 ? "cDataTD" : "cDataTD_odd"%>'><%=BSDateTimeUtil.date2String(license.getEndDate(), dateFormat)%></td>
		<td class='<%=index % 2 == 0 ? "cDataTD" : "cDataTD_odd"%>'><%=getCause(request, license)%></td>
		<td class='<%=index % 2 == 0 ? "cDataTD" : "cDataTD_odd"%>'><%=license.getDocument() == null ? "" : license.getDocument()%></td>
	</tr>
	<%
		}
	%>
</table>

<hr>
<button onclick="javascript:showDialog()">Agregar</button>
<a class="cCancel"
	href="${pageContext.request.contextPath}/servlet/config/employee/EmployeeManager">Volver</a>

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
							for (LicenseCause cause : causes) {
						%>
						<option value="<%=cause.getId()%>"><%=cause.getName()%></option>
						<%
							}
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

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
<%!private String getCause(HttpServletRequest request, License license) {
		Connection conn = (Connection) request.getAttribute("Connection");
		BSmySQL mysql = new BSmySQL();
		String name = mysql.queryField(conn, "SELECT cName FROM tLicenseCause WHERE cId=?", license.getLicenseCause());

		return name;
	}%>
