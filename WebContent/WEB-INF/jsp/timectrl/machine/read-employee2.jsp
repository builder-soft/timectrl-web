<%@page import="cl.buildersoft.timectrl.business.beans.Employee"%>
<%@page import="cl.buildersoft.timectrl.business.services.impl.EmployeeAndFingerprint" %>
<%@page import="cl.buildersoft.timectrl.business.beans.Area"%>
 
<%@page import="cl.buildersoft.timectrl.business.beans.Privilege"%>
<%@page import="java.sql.Connection"%>
<%@page import="cl.buildersoft.framework.database.BSmySQL"%>
<%@page
	import="cl.buildersoft.timectrl.business.services.impl.PrivilegeServiceImpl"%>
<%@page
	import="cl.buildersoft.timectrl.business.services.PrivilegeService"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Machine"%>
<%@ include file="/WEB-INF/jsp/common/header2.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu2.jsp"%>
<%
	List<EmployeeAndFingerprint> employees = (List<EmployeeAndFingerprint>) request.getAttribute("EAFListMch");
	List<EmployeeAndFingerprint> employeesDB = (List<EmployeeAndFingerprint>) request.getAttribute("EAFListDB");
	List<Area> areaList = (List<Area>) request.getAttribute("AreaList");
	List<Privilege> privilegeList = (List<Privilege>) request.getAttribute("PrivilegeList");
	Machine machine =(Machine) request.getAttribute("Machine");
%>
<script
	src="${pageContext.request.contextPath}/js/timectrl/machine/read-employee2.js?<%=BSWeb.randomString()%>">
	
</script>

<div class="page-header">
<h1>Empleados registrados</h1>
</div>

<div class="row">
<div class="col-xs-6">


<!-- 
<table width="100%" border="0">
	<tr>
		<td valign="top">
		 -->
			<div style="height: 400px; overflow: scroll;">
				<form id="DatabaseUser" method="post">
					<input type="hidden" name="Machine" value="<%=machine.getId()%>">
					<table class="table table-striped table-bordered table-hover table-condensed table-responsive"  
						id="employeeTable">
						<%
							if (areaList != null) {
						%>
						<caption>
							Usuarios del área: <select name="Area"
								onchange="javascript:changeArea(this)">
								<%
									for (Area area : areaList) {
								%>
								<option value="<%=area.getId()%>"><%=area.getName()%></option>
								<%
									}
								%>
							</select>
						</caption>
						<%
							}
						%>
						<tr>
							<td class='cHeadTD' style="text-align: center"><input
								type="checkbox" onclick="javascript:checkAll(this)"></td>
							<td class='cHeadTD'>Id.</td>
							<td class='cHeadTD'>Nombre</td>
							<!-- 
							<td class='cHeadTD' style="text-align: center">Habilitado</td>
							<td class='cHeadTD' style="text-align: center">Privilegio</td>
							 -->
							<td class='cHeadTD' style="text-align: center">Huella<br>Digital
							</td>
						</tr>
						<%
							PrivilegeService ps = new PrivilegeServiceImpl();
							for (EmployeeAndFingerprint eaf : employeesDB) {
						%>
						<tr>
							<td class='cDataTD' style="text-align: center"><input
								name="cKey" type="checkbox" value="<%=eaf.getEmployee().getKey()%>"></td>
							<td class='cDataTD'><%=eaf.getEmployee().getKey()%></td>
							<td class='cDataTD'><%=eaf.getEmployee().getName()%></td>
							<!-- 
							<td class='cDataTD' style="text-align: center"><%=eaf.getEmployee().getEnabled() ? "Si" : "No"%></td>
							<td class='cDataTD' style="text-align: center"><%=getPrivililege(privilegeList, eaf.getEmployee().getPrivilege())%></td>
							 -->
							<td class='cDataTD' style="text-align: center"><%=eaf.getFingerprint().getFingerprint() == null ? "No" : "Si"%></td>
						</tr>
						<%
							}
						%>
					</table>
				</form>
				
			</div>
			<button onclick="javascript:addEmployee()">Copiar a
				dispositivo</button>
		<!--	
		</td>
		 
		<td align="center">
			<button style:"width:100%">-></button> <br>
			<button width="100%"><-</button>
		</td>
		 
		<td valign="top">
		-->
		</div>
		<div class="col-xs-6">
		
			<div style="height: 400px; overflow: scroll;">
				<form id="MachineUsers" method="post">
					<input type="hidden" name="Machine" value="<%=machine.getId()%>">
					<table class="table table-striped table-bordered table-hover table-condensed table-responsive">
						<caption>
							Usuarios en dispositivo (<%=machine.getName()%>)
							<%=employees.size() %>
						</caption>
						<tr>
							<td class='cHeadTD' style="text-align: center"><input
								type="checkbox" onclick="javascript:checkAll(this)"></td>
							<td class='cHeadTD'>Id.</td>
							<td class='cHeadTD'>Nombre</td>
							<td class='cHeadTD' style="text-align: center">Habilitado</td>
							<td class='cHeadTD' style="text-align: center">Privilegio</td>
						</tr>
						<%
							for (EmployeeAndFingerprint employee : employees) {
						%>
						<tr>
							<td class='cDataTD' style="text-align: center"><input
								name="cKey" type="checkbox" value="<%=employee.getEmployee().getKey()%>"></td>
							<td class='cDataTD'><%=employee.getEmployee().getKey()%></td>
							<td class='cDataTD'><%=employee.getEmployee().getName()%></td>
							<td class='cDataTD' style="text-align: center"><%=employee.getEmployee().getEnabled() ? "Si" : "No"%></td>
							<td class='cDataTD' style="text-align: center"><%=getPrivililege(privilegeList, employee.getEmployee().getPrivilege())%></td>
						</tr>
						<%
							}
						%>
					</table>
				</form>
			</div>
			<button onclick="javascript:syncUserinfo();">Sincronizar
				usuarios seleccionados</button>
			<button onclick="javascript:deleteEmployees()">Borrar
				usuarios</button>
			
	<!-- 		
			
		</td>
	</tr>
	
	
	<tr>
		<td><button onclick="javascript:addEmployee()">Copiar a
				dispositivo</button></td>
		
		<td>
			<button onclick="javascript:syncUserinfo();">Sincronizar
				usuarios seleccionados</button>
			<button onclick="javascript:deleteEmployees()">Borrar
				usuarios</button>
		</td>
</table>
 -->
 
 </div></div>
 
 
<br>
<a class="cCancel"
	href="${pageContext.request.contextPath}/servlet/timectrl/machine/MachineManager">Volver</a>
<%
	//	(new BSmySQL()).closeConnection(conn);
%>
<%@ include file="/WEB-INF/jsp/common/footer2.jsp"%>

<%!String getPrivililege(List<Privilege> privilegeList, Long privilege) {
		//User privilege. 0: common user, 1: enroller, 2: administrator, 3: super administrator
		String out = null;

		for (Privilege p : privilegeList) {
			if (privilege.equals(p.getId())) {
				out = p.getName();
				break;
			}
		}

		if (out == null) {
			out = "Rol desconocido (" + privilege + ")";
		}
		return out;
	}%>