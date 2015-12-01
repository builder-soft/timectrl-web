<%@page import="cl.buildersoft.web.servlet.timectrl.employee.DetailFile"%>
<%@ include file="/WEB-INF/jsp/common/header2.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu2.jsp"%>
<%
	List<DetailFile> list = (List<DetailFile>) request.getAttribute("ListFile");
	Integer count = 0;
%>

<div class="page-header">
	<h1>Resultado de carga de licencias</h1>
</div>

<table
	class="table table-striped table-bordered table-hover table-condensed">
	<thead>
		<tr>
			<td>Fila Archivo</td>
			<td>Rut</td>
			<td>Tipo</td>
			<td>Fecha Inicio</td>
			<td>Fecha Termino</td>
			<td>Comentario</td>
		</tr>
	</thead>
	<tbody>
		<%
			for (DetailFile detail : list) {
				if (detail.getMessage() != null) {
					count++;
		%>
		<tr>
			<td><%=detail.getRowNumber()%></td>
			<td><%=detail.getRut()%></td>
			<td><%=detail.getType()%></td>
			<td><%=detail.getStart()%></td>
			<td><%=detail.getEnd()%></td>
			<td><%=detail.getMessage()%></td>
		</tr>
		<%
			}
			}
		%>
	</tbody>
</table>

<Label class="cLabel">Se procesaron <%=list.size()%> registros,
	y fueron encontrados <%=count%> con error.
</Label>
<br>
<br>
<a class="cCancel"
	href="${pageContext.request.contextPath}/servlet/config/employee/EmployeeManager">Aceptar</a>

<%@ include file="/WEB-INF/jsp/common/footer2.jsp"%>

