<%@page import="cl.buildersoft.timectrl.business.beans.TurnDay"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Privilege"%>
<%@page import="cl.buildersoft.timectrl.business.beans.Employee"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	TurnDay turnDay = (TurnDay) request.getAttribute("TurnDay");
	String currentRow = (String)request.getAttribute("CurrentRow");
	Boolean businessDay = turnDay.getBusinessDay();
	Integer day = turnDay.getDay();
	Integer edgePostIn = turnDay.getEdgePostIn();
	Integer edgePostOut = turnDay.getEdgePostOut();
	Integer edgePrevIn = turnDay.getEdgePrevIn();
	Integer edgePrevOut = turnDay.getEdgePrevOut();
	String endTime = turnDay.getEndTime();
	String startTime = turnDay.getStartTime();
	Long turn = turnDay.getTurn();
%>
{
"day":"<%=day%>",
"edgePostIn":"<%=edgePostIn%>",
"edgePostOut":"<%=edgePostOut%>",
"edgePrevIn":"<%=edgePrevIn%>",
"edgePrevOut":"<%=edgePrevOut%>",
"endTime":"<%=endTime%>",
"startTime":"<%=startTime%>",
"turn":"<%=turn%>",
"currentRow":"<%=currentRow%>",
"businessDay":"<%=businessDay%>"
}

