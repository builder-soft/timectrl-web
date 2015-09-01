<%@page import="java.sql.ResultSet"%>
<%
	String param = (String) request.getParameter("Key");
	Object data = request.getAttribute(param);
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
	padding: 3px 8px 0; #
	background-color: #444;
	border: 1px solid #666; #
	font-size: 15px;
}

ul.tabHolder li.active {
	background-color: #F0F0F0;
	border-bottom-color: #944;
}

.content {
	background-color: #F8F8F8; #
	height: 1em;
	border: 1px solid #666;
}
-->
</style>
<script type="text/javascript">
	function changeTab(clicked) {
		var tables = [ 'DivEmployee', 'DivBoss', 'DivArea' ];

		for ( var i in tables) {
			document.getElementById(tables[i]).style.display = 'none';
			document.getElementById(tables[i].replace('Table', 'Tab')).className = '';
		}

		$(document.getElementById(clicked.id.replace('Tab', 'Table'))).fadeIn(
				speed);
		//	document.getElementById(clicked.id.replace('Tab', 'Table') ).style.display = '';
		document.getElementById(clicked.id).className = 'active';
	}
</script>
<!-- 
<label class="cLabel">
<%=data.getClass().getName()%>
</label>
 -->
<td class='cLabel' colspan=2>Seleccion de empleado
	<div class="menu">
		<ul class="tabHolder">
			<li id='TabEmployee' class="active" onclick='changeTab(this)'>B&uacute;scar
				por Empleado</li>
			<li id='TabBoss' onclick='changeTab(this)'>B&uacute;squeda por
				Jefatura</li>
			<li id='TabArea' onclick='changeTab(this)'>B&uacute;squeda por
				&Aacute;rea</li>
		</ul>
	</div>
	<div class="content">
		<div id='DivEmployee'>
			<table>
				<tr>
					<td>Rut</td><td>Nombre</td>
				</tr>
				<tr>
					<td><input list='EmployeeRutList'></td>
				 
					<td><input></td>
				</tr>
				<tr>
				<td><table class="cTable">
				<tr><td></td></tr>
				</table>
			</table>
		</div>
		
		<div id='DivBoss' style='display: none'>
			<tr>
				<td>Jefatura:</td>
				<td><select></td>
			</tr>
		</div>
		<div id='DivArea' style='display: none'>
			<tr>
				<td>Area:</td>
				<td><select></td>
			</tr>
		</div>
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
