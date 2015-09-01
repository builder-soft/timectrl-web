<%@page import="java.sql.ResultSet"%>
<%
String param = (String)request.getParameter("Key");
//ResultSet employeeList = (ResultSet) request.getAttribute(param);
%>
<style>
<!--
.menu {
	border-bottom: 1px solid #666;
}

ul.tabHolder {
	overflow: hidden;
	margin: 1em 0 -2px;
	padding: 0;
	cursor: pointer;
	cursor: hand;
}

ul.tabHolder li {
	list-style: none;
	display: inline-block;
	margin: 0 3px;
	padding: 3px 8px 0; 
	#background-color: #444;
	border: 1px solid #666; 
	#font-size: 15px;
}

ul.tabHolder li.active {
	background-color: #F0F0F0;
	border-bottom-color: #944;
}

.content {
	background-color: #F8F8F8; 
	#height: 1em;
	border: 1px solid #666;
}
-->
</style>
<script type="text/javascript">
<!--
function changeTab(clicked){
	var tables = ['TableEmployee', 'TableBoss', 'TableArea'];
	
	for(var i in tables){
		document.getElementById(tables[i]).style.display = 'none';
		document.getElementById(tables[i].replace('Table', 'Tab') ).className='';
	}

	$(document.getElementById(clicked.id.replace('Tab', 'Table'))).fadeIn(speed);
//	document.getElementById(clicked.id.replace('Tab', 'Table') ).style.display = '';
	document.getElementById(clicked.id).className = 'active';
}
//-->
</script>
<td class='cLabel' colspan=2>Seleccion de empleado
	<div class="menu">
		<ul class="tabHolder">
			<li id='TabEmployee' class="active" onclick='changeTab(this)'>Empleado</li>
			<li id='TabBoss' onclick='changeTab(this)'>Jefatura</li>
			<li id='TabArea' onclick='changeTab(this)'>&Aacute;rea</li>
		</ul>
	</div>
	<div class="content">
		<table id='TableEmployee'> 
			<tr>
				<td>Rut:</td>
				<td><input list='EmployeeRutList'></td></tr><tr>
				<td>Nombre:</td>
				<td><input></td></tr>
		</table>
		<table id='TableBoss' style='display:none'>
			<tr>
				<td>Jefatura:</td>
				<td><select></td>
		</table>
		<table id='TableArea' style='display:none'>
			<tr>
				<td>Area:</td>
				<td><select></td>
		</table>
	</div>

</td>

<datalist id='EmployeeRutList'>
 
</datalist>
		
<!-- 
<td class='cLabel'>Seleccion de empleado

	<ul>
		<li>Persona
			<ul>
				<li>X RUT</li>
				<li>X Nombre</li>
			</ul>
		</li>
		<li>Jefatura</li>
		<li>&Aacute;rea</li>
	</ul>
	
	
	
	 <!-- 
•	Jefatura
o	Nombre del Jefe (Supervisor, Jefe, Sub-Gerente, Gerente y Vicepresidente)
•	Área
o	Sub-Gerencia
o	Gerencia
o	Vicepresidencia
o	Centro de Costo
	X Nombre
	X Número
 -->
