<%@page import="cl.buildersoft.timectrl.business.beans.Privilege"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Employee"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
List<Employee> employees = (List<Employee>)request.getAttribute("Employee");
List<Privilege> privilegeList = (List<Privilege>)request.getAttribute("PrivilegeList");

Integer size = employees.size();
Integer i = 0;
%>

[
<%for(Employee employee : employees){
	i++;
%>
    {"id": "<%=employee.getId()%>", "key":"<%=employee.getKey()%>", "name":"<%=employee.getName()%>", "enabled":"<%=employee.getEnabled()%>", "privilege":"<%=getPrivililege(privilegeList, employee.getPrivilege())%>", "fingerprint":"<%=employee.getFingerPrint()!=null%>"}<%=i<size?",":""%> 
<%}%>
]

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