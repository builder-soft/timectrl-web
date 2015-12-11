<%@page import="cl.buildersoft.timectrl.business.beans.Post"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Employee"%>
<%@page import="java.util.Map"%>
<%@page import="cl.buildersoft.framework.beans.BSBean"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String param = (String) request.getParameter("Key");
	Map<String, List<? extends BSBean>> employeeMap = (Map<String, List<? extends BSBean>>) request.getAttribute(param);
	List<Employee> bossList = (List<Employee>) employeeMap.get("BOSS_LIST");
	List<Post> postList = (List<Post>) employeeMap.get("POST_LIST");
%>
<td class="cLabel">${param["Label"]}:</td>
<td class="cData"><select id='${param["Name"]}'
	name='${param["Name"]}' onchange="javascript:_changeBoss(this)">
		<option value="0">- Seleccione una jefatura -</option>
		<%
			for (Employee boss : bossList) {
		%>
		<option value="<%=boss.getId()%>"><%=boss.getRut()%>
			-
			<%=boss.getName()%> (<%=getPost(postList, boss.getPost())%>)
		</option>
		<%
			}
		%>
</select>
 
</td>
<script>
function changeBoss(bossSelect){
	var disable = bossSelect.value=='';
	
	document.getElementById("raiseQuery").disabled = disable;
//	alert('-'+bossSelect.value+'-');
}

function onLoadPage(){
//	document.getElementById("raiseQuery").disabled = true;
}
</script>
<%!private String getPost(List<Post> postList, Long id) {
		String out = "";
		for (Post post : postList) {
			if (post.getId().equals(id)) {
				out = post.getName();
				break;
			}
		}
		return out;
	}%>