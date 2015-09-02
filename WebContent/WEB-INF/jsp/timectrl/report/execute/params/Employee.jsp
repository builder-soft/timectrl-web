<%@page import="cl.buildersoft.timectrl.business.beans.Area"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Employee"%>
<%@page import="cl.buildersoft.framework.beans.BSBean"%>
<%@page import="java.util.Map"%>
<%@page
	import="cl.buildersoft.timectrl.business.beans.ReportParameterBean"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.ResultSet"%>
<%
	String param = (String) request.getParameter("Key");
Map<String, List<? extends BSBean>> dataList = (Map<String, List<? extends BSBean>>)request.getAttribute(param);
//List<ReportParameterBean> dataList = (List<ReportParameterBean>)request.getAttribute(param);

List<Employee> employeeList = (List<Employee>)dataList.get("EMPLOYEE_LIST");
List<Area> areaList = (List<Area>)dataList.get("AREA_LIST");
List<Employee> bossList = (List<Employee>)dataList.get("BOSS_LIST");

// EMPLOYEE_LIST
// AREA_LIST
// BOSS_LIST
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
	border: 1px solid #666;
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
			document.getElementById(tables[i].replace('Div', 'Tab')).className = '';
		}

		$(document.getElementById(clicked.id.replace('Tab', 'Div'))).fadeIn(
				speed);
		//	document.getElementById(clicked.id.replace('Tab', 'Table') ).style.display = '';
		document.getElementById(clicked.id).className = 'active';
	}

	function onLoadPage() {
		setInterval(verifyChanges, 1000);
	}
	var rut = '';
	var name = '';
	function verifyChanges() {
		var rutValue = document.getElementById('Rut').value;
		var nameValue = document.getElementById('Name').value;

		if (rut != rutValue || name != nameValue) {
			rut = rutValue;
			name = nameValue;
//			alert('submit');
			label.innerHTML = 'submit ' + rut + ' ' + rutValue + ' - ' + name + ' ' + nameValue;
		}
	}
</script>
<!-- 
<label class='cLabel'>
<%=dataList.getClass().getName()%>
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
			<table border=0 width='100%'>
				<tr>
					<td>Rut</td>
					<td>Nombre</td>
				</tr>
				<tr>
					<td><input list='RutList' id='Rut'></td>
					<td><input list='NameList' id='Name'></td>
				</tr>
				<tr>
					<td colspan='2'>
						<div style='height: 100px; overflow: auto'>
							<table class="cList" cellpadding="0" cellspacing="0" width='50%'>
								<tr>
									<td class='cHeadTD'>Selecci&oacute;n</td>
									<td class='cHeadTD'>Rut</td>
									<td class='cHeadTD'>Nombre</td>
								</tr>
								<%
									for (Employee employee : employeeList) {
								%>
								<tr>
									<td class='cDataTD'><input type="radio"></td>
									<td class='cDataTD'><%=employee.getRut()%></td>
									<td class='cDataTD'><%=employee.getName()%></td>
								</tr>
								<%
									}
								%>
							</table>
						</div>
					</td>
				</tr>
			</table>
		</div>

		<div id='DivBoss' style='display: none'>
			<table>
				<tr>
					<td>Jefatura:</td>
					<td><select></td>
				</tr>
			</table>
		</div>
		<div id='DivArea' style='display: none'>
			<table>
				<tr>
					<td>Area:</td>
					<td><select></td>
				</tr>
			</table>
		</div>
	</div>
	<br>
<label class='cLabel' id='label'/>

</td>

<datalist id='RutList'>
	<%
		for (Employee employee : employeeList) {
	%>
	<option value='<%=employee.getRut()%>' />
	<%
		}
	%>
</datalist>
<datalist id='NameList'>
	<%
		for (Employee employee : employeeList) {
	%>
	<option value='<%=employee.getName()%>' />
	<%
		}
	%>
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
