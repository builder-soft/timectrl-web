<%@page
	import="cl.buildersoft.timectrl.business.services.impl.EmployeeServiceImpl"%>
<%@page
	import="cl.buildersoft.timectrl.business.services.EmployeeService"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.Collections"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Area"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Employee"%>
<%@page import="cl.buildersoft.framework.beans.BSBean"%>
<%@page import="java.util.Map"%>
<%@page
	import="cl.buildersoft.timectrl.business.beans.ReportParameterBean"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.ResultSet"%>
<%
	//	String param = (String) request.getParameter("Key");
	//Map<String, List<? extends BSBean>> dataList = (Map<String, List<? extends BSBean>>)request.getAttribute(param);
	//List<ReportParameterBean> dataList = (List<ReportParameterBean>)request.getAttribute(param);

	//List<Employee> employeeList = (List<Employee>)dataList.get("EMPLOYEE_LIST");
	//List<Area> areaList = (List<Area>)dataList.get("AREA_LIST");
	//List<Employee> bossList = (List<Employee>)dataList.get("BOSS_LIST");

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
	var rut = '_';
	var name = '';
	var refreshTime = 500;

	var employeeTimerId = null;
	var bossTimerId = null;
	var areaTimerId = null;

	function changeTab(clicked) {
		var tables = [ 'DivEmployee', 'DivBoss', 'DivArea' ];

		for ( var i in tables) {
			document.getElementById(tables[i]).style.display = 'none';
			document.getElementById(tables[i].replace('Div', 'Tab')).className = '';
		}

		$(document.getElementById(clicked.id.replace('Tab', 'Div'))).fadeIn(
				speed);

		document.getElementById(clicked.id).className = 'active';

		clearInterval(employeeTimerId);
		clearInterval(bossTimerId);
		clearInterval(areaTimerId);

		rut = '_';
		switch (clicked.id) {
		case "TabEmployee":
			employeeTimerId = setInterval(verifyChanges, refreshTime,
					'Employee');
			break;
		case "TabBoss":
			bossTimerId = setInterval(verifyChanges, refreshTime, 'Boss');
			break;
		case "TabArea":
			alert("area");
			break;
		default:
			break;
		}
	}

	function onLoadPage() {
		changeTab(document.getElementById("TabEmployee"));
		//		employeeTimerId = setInterval(verifyChanges, refreshTime, 'Employee');

	}
	function verifyChanges(entity) {
		var rutValue = document.getElementById(entity + 'Rut').value;
		var nameValue = document.getElementById(entity + 'Name').value;

		if (rut != rutValue || name != nameValue) {
			rut = rutValue;
			name = nameValue;

			var url = contextPath
					+ "/servlet/timectrl/report/execute/ListEmployeeAjax";

			$.ajax({
				type : "GET",
				cache : false,
				url : url,
				data : {
					Rut : rut,
					Name : name,
					Type : entity
				},
				async : true,
				success : retieveEmployeeList,
				error : function(data, textStatus, xhr) {
					alert(xhr);
				}
			});

		}
	}
	function retieveEmployeeList(data, status) {
		var type = data.type;
		var table = document.getElementById(type + "Table");

		for (var i = table.rows.length; i > 1; i--) {
			table.deleteRow(i - 1);
		}

		var employees = data.employees;

		for ( var i in employees) {
			var row = table.insertRow(-1);
			var cell = row.insertCell(0);
			cell.className = 'cDataTD';
			cell.innerHTML = '<input onclick="selectRow(this,\'' + type
					+ '\')" name="cId" type="radio" value="' + employees[i].id
					+ '">';

			cell = row.insertCell(1);
			cell.className = 'cDataTD';
			cell.innerHTML = employees[i].rut;

			cell = row.insertCell(2);
			cell.className = 'cDataTD';
			cell.innerHTML = employees[i].name;

		}
	}

	function selectRow(r, type) {
		if (type.toLowerCase() == 'boss') {
			retrieveEmployees(r.value);
		} else {
			document.getElementById("Id").value = r.value;
		}
	}

	function retrieveEmployees(bossId) {
		var url = contextPath
				+ "/servlet/timectrl/report/execute/RetrieveEmployeeAjax";

		$.ajax({
			type : "GET",
			cache : false,
			url : url,
			data : {
				BossId : bossId
			},
			async : true,
			success : function(data, status) {
				document.getElementById("Id").value = data;
			},
			error : function(data, textStatus, xhr) {
				alert(xhr);
			}
		});
	}
</script>

<td class='cLabel' colspan=2>Seleccion de empleado
	<div class="menu">
		<ul class="tabHolder">
			<li id='TabEmployee' class="active" onclick='changeTab(this)'>B&uacute;scar
				por Empleado</li>
			<li id='TabBoss' onclick='changeTab(this)'>B&uacute;squeda por
				Jefatura</li>
				  
			<li style='display: none' id='TabArea' onclick='changeTab(this)'>B&uacute;squeda por
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
					<td><input id='EmployeeRut' autocomplete="off"></td>
					<td><input id='EmployeeName' autocomplete="off"></td>
				</tr>
				<tr>
					<td colspan='2'>
						<div style='height: 100px; overflow: auto'>
							<table id='EmployeeTable' class="cList" cellpadding="0"
								cellspacing="0" width='50%'>
								<tr>
									<td class='cHeadTD'>Selecci&oacute;n</td>
									<td class='cHeadTD'>Rut</td>
									<td class='cHeadTD'>Nombre</td>
								</tr>
								<tr>
									<td style='text-align: center' valign="middle" class='cDataTD'
										colspan='3'><br> <img
										src="${pageContext.request.contextPath}/img/loading/6.gif"><br></td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
		</div>

		<div id='DivBoss' style='display: none'>
			<table border=0 width='100%'>
				<tr>
					<td>Rut</td>
					<td>Nombre</td>
				</tr>
				<tr>
					<td><input id='BossRut' autocomplete="off"></td>
					<td><input id='BossName' autocomplete="off"></td>
				</tr>
				<tr>
					<td colspan='2'>
						<div style='height: 100px; overflow: auto'>
							<table id='BossTable' class="cList" cellpadding="0"
								cellspacing="0" width='50%'>
								<tr>
									<td class='cHeadTD'>Selecci&oacute;n</td>
									<td class='cHeadTD'>Rut</td>
									<td class='cHeadTD'>Nombre</td>
								</tr>
								<tr>
									<td style='text-align: center' valign="middle" class='cDataTD'
										colspan='3'><br> <img
										src="${pageContext.request.contextPath}/img/loading/6.gif"><br></td>
								</tr>
							</table>
						</div>
					</td>
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
	</div> <br> <input name='${param["Name"]}' id='Id' type='text'>




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

</td>

