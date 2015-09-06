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
	var rut = '_';
	var name = '';
	function verifyChanges() {
		var rutValue = document.getElementById('Rut').value;
		var nameValue = document.getElementById('Name').value;

		if (rut != rutValue || name != nameValue) {
			rut = rutValue;
			name = nameValue;

			var url = contextPath
					+ "/servlet/timectrl/report/execute/ListEmployeeAjax"; // ?Rut="
			//					+ rut + "&Name=" + name;

			//			alert('will submit');

			$.ajax({
				type : "GET",
				cache : false,
				url : url,
				data : {
					Rut : rut,
					Name : name
				},
				async : false,
				success : retieveEmployeeList,
				error : function(data, textStatus, xhr) {
					alert(xhr);
				}
			});

			//			$.get(url, retieveEmployeeList);

			//			label.innerHTML = 'submit ' + rut + ' ' + rutValue + ' - ' + name + ' ' + nameValue;

		}
	}
	function retieveEmployeeList(data, status) {
		//		alert(status);
		var table = document.getElementById("EmployeeTable");
		for ( var i = table.rows.length; i > 1; i--) {
			table.deleteRow(i - 1);
		}

		for ( var i in data) {
			var row = table.insertRow(-1);
			var cell = row.insertCell(0);
			cell.className = 'cDataTD';
			cell.innerHTML = '<input onclick="selectRow(this)" name="cId" type="radio" value="'
					+ data[i].id + '">';

			cell = row.insertCell(1);
			cell.className = 'cDataTD';
			cell.innerHTML = data[i].rut;

			cell = row.insertCell(2);
			cell.className = 'cDataTD';
			cell.innerHTML = data[i].name;

			$(row).fadeIn(speed);

		}

	}

	function selectRow(r) {
		//		alert(r);
		document.getElementById("Id").value = r.value;
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
					<td><input list='NameList' id='Name' autocomplete="off"></td>
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
									<td style='text-align: center' valign='center' class='cDataTD'
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
	</div> <br> <!-- 
<label class='cLabel' id='label'/>
 --> <input name='Id' id='Id' type='text'> <datalist
		id='NameList'>
		<%
			for (Employee employee : employeeList) {
		%>
		<option value='<%=employee.getName()%>' />
		<%
			}
		%>
	</datalist> <datalist id='RutList'>
		<%
			sortByRut(employeeList);
			for (Employee employee : employeeList) {
		%>
		<option value='<%=employee.getRut()%>' />
		<%
			}
		%>
	</datalist> <!-- 
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

<%!private void sortByName(List<Employee> employeeList) {
		EmployeeService es = new EmployeeServiceImpl();

		es.sortByName(employeeList);

	}

	private void sortByRut(List<Employee> employeeList) {
		EmployeeService es = new EmployeeServiceImpl();

		es.sortByRut(employeeList);

	}%>