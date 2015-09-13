<%@page import="cl.buildersoft.timectrl.business.beans.Employee"%>
<%@page import="java.util.Map"%>
<%@page import="cl.buildersoft.framework.beans.BSBean"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
String param = (String)request.getParameter("Key");
Map<String, List<? extends BSBean>> employeeMap = (Map<String, List<? extends BSBean>>) request.getAttribute(param);
	
List<Employee> bossList=	(List<Employee>)employeeMap.get("BOSS_LIST");
	
%>
<td class="cLabel">${param["Label"]}:</td>
<td class="cData"><select name='${param["Name"]}'>
		<option value="0">- Todas las personas -</option>
		<%
			for (Employee boss : bossList ) {
		%>
		<option value="<%=boss.getId()%>"><%=boss.getRut()%>
			-
			<%=boss.getName()%></option>
		<%
			}
		%>
</select></td>