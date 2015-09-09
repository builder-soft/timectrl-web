<%@page import="cl.buildersoft.timectrl.business.beans.Privilege"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Employee"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	List<Employee> employees = (List<Employee>) request.getAttribute("EmployeeList");
	Integer i = 0;
	Integer size = employees.size();
	String value = "";
	for (Employee employee : employees) {
		i++;
		value += (employee.getId() + (i < size ? "," : ""));
	}
%>
<%=value%>