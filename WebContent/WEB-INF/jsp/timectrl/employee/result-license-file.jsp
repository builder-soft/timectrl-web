<%@page import="cl.buildersoft.web.servlet.timectrl.employee.DetailFile"%>
<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>
<%
	List<DetailFile> list = (List<DetailFile>) request.getAttribute("ListFile");
	Integer count = 0;
%>
<h1 class="cTitle">Resultado de carga de licencias</h1>


<table class="cList" cellpadding="0" cellspacing="0">
	<tr>
		<td class='cHeadTD'>Fila Archivo</td>
		<td class='cHeadTD'>Rut</td>
		<td class='cHeadTD'>Tipo</td>
		<td class='cHeadTD'>Fecha Inicio</td>
		<td class='cHeadTD'>Fecha Termino</td>
		<td class='cHeadTD'>Comentario</td>
	</tr>
	<%
		for (DetailFile detail : list) {
			if (detail.getMessage() != null) {
				count++;
	%>
	<tr>
		<td class='cDataTD'><%=detail.getRowNumber()%></td>
		<td class='cDataTD'><%=detail.getRut()%></td>
		<td class='cDataTD'><%=detail.getType()%></td>
		<td class='cDataTD'><%=detail.getStart()%></td>
		<td class='cDataTD'><%=detail.getEnd()%></td>
		<td class='cDataTD'><%=detail.getMessage()%></td>
	</tr>
	<%
		}
		}
	%>
</table>

<Label class="cLabel">Se procesaron <%=list.size()%> registros,
	y fueron encontrados <%=count%> con error.
</Label>
<br>
<br>
<a class="cCancel"
	href="${pageContext.request.contextPath}/servlet/config/employee/EmployeeManager">Aceptar</a>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>

