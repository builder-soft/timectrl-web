<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>

		<h1 class="cTitle">Commons File Upload Example</h1>
	
		<form action="${pageContext.request.contextPath}/servlet/file/Upload" enctype="multipart/form-data" method="POST">
<!-- 		
		<form action="${pageContext.request.contextPath}/servlet/ShowParameters" enctype="multipart/form-data" method="POST">
		 -->
			<input type="file" name="file1"><br>
			<input type="text" name="desc"><br>
			<input type="Submit" value="Upload File"><br>
		</form>
<br><br><br>
<a href="http://commons.apache.org/fileupload/using.html">Help here</a>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>

