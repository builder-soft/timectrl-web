<%@page import="cl.buildersoft.framework.beans.User"%>
<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>
<%
	User me = (User) session.getAttribute("User");
	User current = (User) request.getAttribute("User");

	Long id = null;
	Boolean admin = null;
	String mail = null;
	String name = null;
	if (current != null) {
		id = current.getId();
		admin = current.getAdmin();
		mail = current.getMail();
		name = current.getName();
	}
%>
<h1 class="cTitle">Datos de usuario</h1>

<form
	action="${pageContext.request.contextPath}/servlet/system/user/UserSave"
	method="post">

	<!-- 
<form action="${pageContext.request.contextPath}/servlet/ShowParameters" method="post">
 -->
	<table>
		<tr>
			<td class="cLabel">Id:</td>
			<td class="cData"><%=id != null ? id : "Nuevo"%><input type="hidden" name="cId" value="<%=id != null ? id : ""%>"></td>
		</tr>
		<tr>
			<td class="cLabel">Mail:</td>
			<td class="cData"><input type="text" name="cMail" size="50px" value="<%=mail != null ? mail : ""%>"
				maxlength='50'></td>
		</tr>
		<tr>
			<td class="cLabel">Nombre:</td>
			<td class="cData"><input type="text" name="cName" size="100px" value="<%=name != null ? name : ""%>"
				maxlength='100'></td>
		</tr>
		<%
			if (me.getAdmin()) {
		%>
		<tr>
			<td class="cLabel">Usuario administrador:</td>
			<td class="cData"><input type="checkbox" name="cAdmin" <%=admin != null && admin? "checked" : ""%>></td>
		</tr>
		<%
			}
		%>

	</table>
	<input type="submit" value="Aceptar">
	<a href="${pageContext.request.contextPath}/servlet/system/user/UserManager">Cancelar..</a>
</form>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>

