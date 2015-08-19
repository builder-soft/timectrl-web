<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
String param = (String)request.getParameter("Key");
	ResultSet customerList = (ResultSet) request.getAttribute(param);
%>
<td class="cLabel">${param["Label"]}:</td>
<td class="cData"><select name='${param["Name"]}'>
		<option value="0">- Todas las personas -</option>
		<%
			while (customerList.next()) {
		%>
		<option value="<%=customerList.getString("cId")%>"><%=customerList.getString("cRut")%>
			-
			<%=customerList.getString("cName")%></option>
		<%
			}
		%>
</select></td>