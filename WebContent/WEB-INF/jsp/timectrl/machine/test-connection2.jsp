<%@page import="cl.buildersoft.timectrl.business.beans.Machine"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%>
<%@ include file="/WEB-INF/jsp/common/header2.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu2.jsp"%>
<%
	Map<Machine, Boolean> machines = (Map<Machine, Boolean>) request.getAttribute("Status");
%>

<h1 class="cTitle">Resultado de Prueba de conección</h1>


<table class="table table-striped table-bordered table-hover table-condensed table-responsive">
	<thead>
	<tr>
		<th>Nombre</th>
		<th>Estado</th>
	</tr>
	</thead>
	<tbody>
	<%
		Boolean connected = null;
		for (Machine machine : machines.keySet()) {
			connected = machines.get(machine).booleanValue();
	%>
	<tr>
		<td><%=machine.getName()%> (<%=machine.getIp()%>:<%=machine.getPort()%>)</td>
		<td class="<%=connected?"success":"warning"%>"><%=connected ? "Conectado" : "No encontrado"%></td>
	</tr>
	<%
		}
	%>
	</tbody>
</table>



<!-- 
<table class="cList" cellpadding="0" cellspacing="0">
	<tr>
		<td class='cHeadTD'>Nombre</td>
		<td class='cHeadTD'>Estado</td>
	</tr>
	<%
		for (Machine machine : machines.keySet()) {
	%>
	<tr>
		<td class='cDataTD'><%=machine.getName()%> (<%=machine.getIp()%>:<%=machine.getPort()%>)
		</td>
		<td class='cDataTD'><%=machines.get(machine).booleanValue() ? "Conectado" : "No encontrado"%></td>
	</tr>

	<%
		}
	%>

</table>
 -->

<!-- 
<input type="text" name="SomeObject" id="SomeObject"
	onfocus="javascript:doubleFocus(this);"
	onblur="javascript:doubleBlur(this);"
	value="<%=BSWeb.formatDouble(request, 1234.567)%>">
 -->
<br>
<a class="cCancel"
	href="${pageContext.request.contextPath}/servlet/timectrl/machine/MachineManager">Volver</a>

<%@ include file="/WEB-INF/jsp/common/footer2.jsp"%>
