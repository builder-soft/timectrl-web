<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>

<h1 class="cTitle">Carga de archivos de Licencias</h1>

<form
	action="${pageContext.request.contextPath}/servlet/timectrl/employeeLicense/UploadLicenseFile"
	enctype="multipart/form-data" method="post">
	<label class="cLabel"> Seleccione archivo a cargar:</label><br> <input
		name="FileUploaded" type="file"><br> <br>
	<button type="submit">Cargar</button>
</form>
<br>
<br>
<br>
<br>
<br>
<label class="cLabel">Para obtener un ejemplo del archivo que
	necesita llenar para cargar las licencias de manera masiva, descargue
	el siguiente <a href="${pageContext.request.contextPath}/resources/LicenciasEjemplo2.xlsx">archivo</a>.
</label>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>

