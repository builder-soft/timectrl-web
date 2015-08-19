<%@page import="java.util.Calendar"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	Calendar c = Calendar.getInstance();
Integer year = c.get(Calendar.YEAR);
%>

<td class="cLabel">${param["Label"]}:</td>
<td class="cData"><input type="number" name='${param["Name"]}' min="2012"
	value="<%=year%>" max="<%=year%>"></td>