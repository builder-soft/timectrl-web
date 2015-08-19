<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>
<%
	String nextAction = "/servlet/admin/ChangePassword";
	String cancelAction = "/servlet/admin/UserManager";
	Boolean passwordIsNull = (Boolean) request
			.getAttribute("PASS_IS_NULL");

	Object id = request.getParameter("cId");
	if (id == null) {
		id = (Long) request.getAttribute("cId");
		nextAction += "?GoHome";
		cancelAction = "/servlet/Home";
	}
%>

<h1 class="cTitle">Cambio de clave</h1>
<!-- 
action="${pageContext.request.contextPath}/servlet/admin/ChangePassword"
action="${pageContext.request.contextPath}/servlet/ShowParameters"
 -->
<form action="${pageContext.request.contextPath}<%=nextAction%>"
	method="post">
	<input type="hidden" name="cId" value="<%=id%>">
	<table>
		<%
			if (!passwordIsNull) {
		%>
		<tr>
			<td class="cLabel">Clave anterior:</td>
			<td><input type="password" name="OldPassword"></td>
		</tr>
		<%
			}
		%>
		<tr>
			<td class="cLabel">Nueva clave:</td>
			<td><input type="password" name="NewPassword"></td>
		</tr>
		<tr>
			<td class="cLabel">Confirme clave:</td>
			<td><input type="password" name="CommitPassword"></td>
		</tr>
	</table>
	<input type="submit" value="Confirmar"> <a
		href="${pageContext.request.contextPath}<%=cancelAction%>">Cancelar</a>
</form>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>

