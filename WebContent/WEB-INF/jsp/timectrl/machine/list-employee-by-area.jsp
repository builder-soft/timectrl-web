<%@page import="cl.buildersoft.timectrl.business.services.impl.EmployeeAndFingerprint"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Privilege"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Employee"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
List<EmployeeAndFingerprint> employees = (List<EmployeeAndFingerprint>)request.getAttribute("EmployeeAndFingerprint");
List<Privilege> privilegeList = (List<Privilege>)request.getAttribute("PrivilegeList");

Integer size = employees.size();
Integer i = 0;
%>

[
<%for(EmployeeAndFingerprint eaf : employees){
	i++;
%>
    {"id": "<%=eaf.getEmployee().getId()%>", "key":"<%=eaf.getEmployee().getKey()%>", "name":"<%=eaf.getEmployee().getName()%>", "enabled":"<%=eaf.getEmployee().getEnabled()%>", "privilege":"<%=getPrivililege(privilegeList, eaf.getEmployee().getPrivilege())%>", "fingerprint":"<%=eaf.getFingerprint().getFingerprint()!=null%>"}<%=i<size?",":""%>
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