<%@page import="cl.buildersoft.framework.beans.User"%>
<%@page import="java.sql.ResultSet"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>

<%
	ResultSet rs = (ResultSet) request.getAttribute("Data");
	User user = (User) session.getAttribute("User");
%>

<script
	src="${pageContext.request.contextPath}/js/table/table.js"></script>
<h1 class="cTitle">Listado de Usuarios</h1>


<form id="frm"
	action="${pageContext.request.contextPath}/servlet/system/user/DeleteUser"
	method="post">
	<!-- 
<form id="frm" action="${pageContext.request.contextPath}/servlet/ShowParameters" method="post">
 -->
	<table class="cList" cellpadding="0" cellspacing="0">
		<tr>
			<td align='center' class='cHeadTD'><input id='mainCheck'
				type='CHECKBOX' onclick='javascript:swapAllCheck(this);'></td>
			<td class='cHeadTD'>Mail</td>
			<td class='cHeadTD'>Nombre</td>
			<%
				if (user.getAdmin()) {
			%>
			<td class='cHeadTD'>Administrador</td>
			<%
				}
			%>
		</tr>
		<%
			String color = null;
			Integer i = 0;
			while (rs.next()) {
				color = i % 2 == 0 ? "cDataTD_odd" : "cDataTD";
		%>
		<tr>
			<td align='center' class='<%=color%>'><input type='CHECKBOX'
				name='cId' value='<%=rs.getString("cId")%>'
				onclick='javascript:swapCheck(this);'></td>
			<td class='<%=color%>'><%=rs.getString("cMail")%></td>
			<td class='<%=color%>'><%=rs.getString("cName")%></td>
			<%
				if (user.getAdmin()) {
			%>
			<td class='<%=color%>' align="center"><%=rs.getBoolean("cAdmin") ? "Si" : "No"%></td>
			<%
				i++;
					}
			%>
		</tr>
		<%
			}
		%>
	</table>
</form>
<br>
<div style='float: left;'>
	<button type='button' 
		onclick="javascript:window.location.href='${pageContext.request.contextPath}/servlet/system/user/UserNew'">Nuevo...</button>
</div>
<div id='MultirecordActions' style='float: left; display: none;'>
	<button type='button'  id='oDelete'
		onclick='javascript:fDelete();'>Borrar</button>
</div>

<div id='RecordActions' style='float: left; display: none;'>
	<button type='button' id='oEdit'
		onclick='javascript:doAction("${pageContext.request.contextPath}/servlet/system/user/UserEdit", "EDIT");'>Modificar</button>
		
	<button type='button' id='oCh_pass'
		onclick='javascript:doAction("${pageContext.request.contextPath}/servlet/system/changepassword/SearchPassword", "CH_PASS");'>Cambiar Clave</button>

	<button type='button' id='oRoldef'
		onclick='javascript:doAction("${pageContext.request.contextPath}/servlet/system/roleDef/RoleDef", "ROL_DEF");'>Roles de Usuario</button>		
</div>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
