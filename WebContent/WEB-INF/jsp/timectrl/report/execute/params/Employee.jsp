<%@page import="cl.buildersoft.framework.util.BSTreeNode"%>
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
	Map<String, Object> dataList = (Map<String, Object>) request.getAttribute(param);
	List<BSTreeNode> bossTree = (List<BSTreeNode>) dataList.get("BOSS_TREE");
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
			//alert("area");
			break;
		default:
			break;
		}
	}

	function onLoadPage() {
		changeTab(document.getElementById("TabEmployee"));
		selectAllEmployee(document.getElementById("AllEmployees"));
		
//		$('#tree1').checkboxTree();
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

		for ( var i = table.rows.length; i > 1; i--) {
			table.deleteRow(i - 1);
		}

		var employees = data.employees;

		for (var i in employees) {
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

	function selectAllEmployee(inputObject) {
		if (inputObject.checked) {
			$(document.getElementById("Filtres")).fadeOut(speed);
			document.getElementById("Id").value = "0";
		} else {
			$(document.getElementById("Filtres")).fadeIn(speed);
			rut = '_';
			document.getElementById("Id").value = "";
		}
	}
	
	function clickArea(checkBox){
		var chks = $( "#tree1 input:checkbox:checked" );
		var employees = "";
		var areas = "";
		
		for(var i=0;i<chks.length;i++){
			areas += chks[i].value + ",";
		}
		if(areas.length>0){
			areas = areas.substring(0,areas.length-1);
		}
		employees = getEmployeesByBossId(areas);
		document.getElementById("Id").value = employees;
		
	}
	

	function getEmployeesByBossId(areas) {
		var url = contextPath + "/servlet/timectrl/report/execute/RetrieveEmployeeAjax";
		var out = "";
		$.ajax({
			type : "GET",
			cache : false,
			url : url,
			data : {
				AreasId : areas
			},
			async : false,
			success : function(data, status) {
				out = data;
			},
			error : function(data, textStatus, xhr) {
				alert(xhr);
			}
		});

		return out;
	}
</script>

<td class='cLabel' colspan=2><h3>Seleccion de empleado</h3> <br>
	<input id="AllEmployees" type="checkbox"
	onclick="javascript:selectAllEmployee(this)" checked="true"> <label
	for="AllEmployees">Seleccionar todos los empleados de la
		empresa.</label><br>

	<div id="Filtres" style="display: none">
		<div class="menu">
			<ul class="tabHolder">
				<li id='TabEmployee' class="active" onclick='changeTab(this)'>B&uacute;scar
					por Empleado</li>
				<li id='TabBoss' onclick='changeTab(this)'>B&uacute;squeda por
					Jefatura</li>

				<li style='display: xnone' id='TabArea' onclick='changeTab(this)'>B&uacute;squeda
					por &Aacute;rea</li>

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
			<div id='DivArea' style='display:none'>
				<table>
					<tr>
						<td valign='top'>Area:</td>
						<td>
							<ul id="tree1">								 
								<%=writeTree(bossTree)%>
							</ul>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div> <br> <input name='${param["Name"]}' id='Id' type='hidden'>

</td>
<%!private String writeTree(List<BSTreeNode> bossTree) {
		String out = "";

		for (BSTreeNode node : bossTree) {
			out += drawNode(node);
		}

		return out;
	}

	private String drawNode(BSTreeNode node) {
		String html = "";

		List<BSTreeNode> children = node.getChildren();

		Area area = (Area) node.getValue();
		if (children.size() > 0) {

			html += getLiElement(area);
			html += "<ul>";
			for (BSTreeNode child : children) {
				html += drawNode(child);
			}
			html += "</ul>";
		} else {
			html = getLiElement(area);
		}

		return html;
	}

	private String getLiElement(Area area) {
		String out = "<li class='cLabel' type='none'><input type='checkbox' id='node" + area.getId() + "' value='" + area.getId()
				+ "' onclick='javaScript:clickArea(this)'><label for='node" + area.getId() + "'>" + area.getName()
				+ "</label></li>";
		return out;
	}%>