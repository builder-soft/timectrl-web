<%@ include file="/WEB-INF/jsp/common/header2.jsp"%>
<%
String nextAction = "/servlet/system/changepassword/ChangePassword";
Object id = request.getParameter("cId");
%>
<div class="container">

<div class="page-header">
<h1>Clave de acceso expirada</h1>
</div>

<script type="text/javascript">
 
</script>




<div class="row">
	<div class="col-sm-4 col-sm-offset-1 well">
	

<form action="${pageContext.request.contextPath}<%=nextAction%>"
	method="post" class="form-horizontal" role="form">
	<input type="_hidden" name="cId" value="<%=id%>">
	
	
	</form>


	</div>
</div>
		
		
<!-- 
<div class="well">
	<div class="row ">
		<div class="col-sm-2 ">Fecha inicio:</div>
		<div class="col-sm-4 ">
			<input type="text" id="DStartDate">
		</div>
		<div class="col-sm-2 ">Fecha termino:</div>
		<div class="col-sm-4 ">
			<input type="text" id="DEndDate">
		</div>
	</div>


	<div class="row">
		<div class="col-sm-2 ">Tipo de evento:</div>
		<div class="col-sm-4 ">
			<select></select>
		</div>
		<div class="col-sm-2 ">Usuario:</div>
		<div class="col-sm-4 ">
			<select></select>
		</div>
	</div>
</div>		
		
Fecha:
<input type="text" id="datepicker">
<br>

<table class="table table-striped table-bordered table-hover table-condensed table-responsive">
	<thead>
	<tr>
		<th>encabezado</th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<td>dato</td>
	</tr>
	<tr>
		<td>dato</td>
	</tr>
	</tbody>
</table>

<button class='btn btn-link'
	onclick="returnTo('${pageContext.request.contextPath}/servlet/config/employee/EmployeeManager');">Volver</button>

<div id="divShowDetail" style="display: none">
	<h2 class="cTitle2">Detalle de valores</h2>

	<div class="contentScroll">
		<table class="cList" cellpadding="0" cellspacing="0" id="movesTable">
			<tr>
				<td class="cHeadTD">Detalle</td>
				<td class="cHeadTD">Comentario</td>
				<td class="cHeadTD">Tipo</td>
				<td class="cHeadTD">Monto</td>
			</tr>
		</table>
	</div>
	<br /> 

	<button type="button" class='btn btn-link'
		onclick="javascript:closeTooltip()">Cancelar</button>

</div>
-->

<%@ include file="/WEB-INF/jsp/common/footer2.jsp"%>

