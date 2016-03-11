<%@ include file="/WEB-INF/jsp/common/header.jsp"%>

<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>

<script type="text/javascript">
<!--
	function onLoadPage() {
		//	alert('window.innerHeight '+window.innerHeight);
		//alert(document.getElementById("CurrentVersion").innerText);
		document.getElementById("CurrentVersion").style.top = (window.innerHeight - 75) + 'px';
		//$( "#datepicker" ).datepicker();
	}
//-->
</script>
<h1 class="cTitle">Bienvenidos...</h1>
<!-- 
<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
 -->
 <br>
 <!-- 
<input type="text" id="datepicker"><br>
  -->
  
<div id="CurrentVersion" style="position: absolute">
	<label class="cLabel"> Versión:</label> <label class="cData"><%=request.getAttribute("CurrentVersion")%></label><br>
	<!-- 
	<label class="cLabel"> Última Lectura:</label> <label class="cData"><%=request.getAttribute("LastRead")%></label>
	 -->
</div>
<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
