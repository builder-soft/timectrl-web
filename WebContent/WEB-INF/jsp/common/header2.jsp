<%@page import="cl.buildersoft.framework.util.BSWeb"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>DALEA T&amp;A - Buildersoft</title>

<link
	href="${pageContext.request.contextPath}/bootstrap-334-dist/css/bootstrap.css?<%=BSWeb.randomString()%>"
	rel="stylesheet">
<link
	href="${pageContext.request.contextPath}/plugin/smart-menu/jquery.smartmenus.bootstrap.css"
	rel="stylesheet">
<!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
<script>
	var contextPath = "${pageContext.request.contextPath}";
	var speed = "fast";// "slow" "fast";
	var dateFormat = "${applicationScope.DateFormat}";
</script>
</head>

<body onload="javaScript:try{onLoadPage();}catch(e){}">