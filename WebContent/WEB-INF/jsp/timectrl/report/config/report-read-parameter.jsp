<%@page import="cl.buildersoft.timectrl.business.beans.ReportParameterType"%>
<%@page
	import="cl.buildersoft.timectrl.business.beans.ReportParameterBean"%>
<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>
<%
	List<ReportParameterBean> parameterList = (List<ReportParameterBean>) request.getAttribute("ParameterList");
	List<ReportParameterType> parameterTypeList = (List<ReportParameterType>) request.getAttribute("ParameterTypeList");
	Integer lastOrder = (Integer) request.getAttribute("LastOrder");
%>
<script
	src="${pageContext.request.contextPath}/js/timectrl/report/config/report-read-parameter.js?<%=Math.random()%>">
</script>

<h1 class="cTitle">Parametros de entrada de reporte</h1>

<%@ include file="/WEB-INF/jsp/timectrl/report/config/report-info.jsp"%>


<table class="cList" cellpadding="0" cellspacing="0">
	<tr>
		<td class='cHeadTD'>Sel.</td>
		<td class='cHeadTD'>Nombre</td>
		<td class='cHeadTD'>Etiqueta</td>
		<td class='cHeadTD'>Tipo</td>
		<td class='cHeadTD'>Nombre de Tipo</td>
		<td class='cHeadTD'>Archivo de despliegue</td>
		<td class='cHeadTD'>Origen de datos</td>

		<td class='cHeadTD'>Orden</td>
	</tr>

	<%
		Integer i = 0;
		String color = "";

		ReportParameterType parameterType = null;
		Object source = null;
		for (ReportParameterBean reportInParam : parameterList) {
			color = i % 2 == 0 ? "cDataTD_odd" : "cDataTD";
			parameterType = getParameterType(reportInParam.getTypeId(), parameterTypeList);
			source = parameterType.getSource();
			source = source == null ? "" : source;
	%>
	<tr>
		<td class='<%=color%>'><input type="radio"
			value="<%=reportInParam.getId()%>" name="ParamListId"
			onclick="javascript:selectRow()"></td>
		<td class='<%=color%>'><%=reportInParam.getName()%></td>
		<td class='<%=color%>'><%=reportInParam.getLabel()%></td>

		<td class='<%=color%>'><%=parameterType.getKey()%></td>
		<td class='<%=color%>'><%=parameterType.getName()%></td>
		<td class='<%=color%>'><%=parameterType.getHtmlFile()%></td>
		<td class='<%=color%>'><%=source%></td>

		<td class='<%=color%>'><%=reportInParam.getOrder()%></td>
	</tr>
	<%
		i++;
			}
	%>

</table>

<br>
<button type="button" onclick="javascript:newParameter()">Nuevo
	Parámetro</button>
<button type="button" id="ModifyParam" style="display: none" disabled>Modificar
	Parámetro</button>
<button type="button" id="DeleteParam" style="display: none"
	onclick="javascript:deleteRecord()">Eliminar Parámetro</button>

<a class="cCancel"
	href="${pageContext.request.contextPath}/servlet/timectrl/report/config/ReportManager">Volver</a>

<div id="divShowDetail" style="display: none">
	<h2 class="cTitle2">Parámetro de reporte</h2>

	<form id="formData" method="post">
		<input type="hidden" name="Report" value="${requestScope.Report.id}">
		<input type="hidden" name="ParamId" id="ParamId">
		<table>
			<tr>
				<td class="cLabel">Nombre</td>
				<td><input id="Name" name="Name"></td>
			</tr>
			<tr>
				<td class="cLabel">Etiqueta</td>
				<td><input id="Label" name="Label"></td>
			</tr>
			<tr>
				<td class="cLabel">Tipo</td>
				<td><select id="Type" name="Type">
						<%
							for (ReportParameterType reportParamType : parameterTypeList) {
						%>
						<option value="<%=reportParamType.getId()%>"><%=reportParamType.getName()%></option>
						<%
							}
						%>
				</select></td>
			</tr>
			<!-- 
			<tr>
				<td class="cLabel">Tipo Ingreso</td>
				<td><select id="FromUser" name="FromUser"
					onchange="javascript:changeInputType(this)">
						<option value="true">Ingresado por el usuario</option>
						<option value="false">Parametrizado</option>
				</select></td>
			</tr>
			 
			<tr id="ValueRow">
				<td class="cLabel">Valor</td>
				<td><input id="Value" name="Value"></td>
			</tr>
			-->
			<tr>
				<td class="cLabel">Orden</td>
				<td><input id="Order" name="Order" type="number" maxlength="4"
					size="4" value="<%=lastOrder%>"></td>
			</tr>
		</table>
	</form>

	<br />
	<button onclick="javascript:commitNewRecord()">Aceptar</button>
	<button onclick="javascript:closeTooltip()">Cancelar</button>

</div>


<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>

<%!private ReportParameterType getParameterType(Long id, List<ReportParameterType> list) {
		ReportParameterType out = null;
		for (ReportParameterType current : list) {
			if (current.getId() == id) {
				out = current;
				break;
			}
		}
		return out;
	}%>