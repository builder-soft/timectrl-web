<%@ include file="/WEB-INF/jsp/common/header2.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu2.jsp"%>

<div class="page-header">
	<h1>Carga de archivos de Licencias</h1>
</div>

<form
	action="${pageContext.request.contextPath}/servlet/timectrl/employeeLicense/UploadLicenseFile"
	enctype="multipart/form-data" method="post">

	<div class="row">

		<div class="col-sm-12">
			<label>Seleccione archivo a cargar:</label> <input
				name="FileUploaded" type="file">
		</div>
	</div>
	<div class="row"><div class="col-sm-12">&nbsp;</div></div>
 

	<div class="row">
		<div class="col-sm-12">
			<button type="submit" class='btn btn-default'>Cargar</button>
			<a class='btn btn-link'
	href="${applicationScope['DALEA_CONTEXT']}/servlet/config/employee/EmployeeLicenseManager">Volver</a>
			
		</div>
	</div>

</form>

<div class="row">
	<div class="col-sm-10 col-sm-offset-2">
		<label>Para obtener un ejemplo del archivo que necesita llenar
			para cargar las licencias de manera masiva, descargue el siguiente <a
			class="btn btn-link"
			href="${pageContext.request.contextPath}/resources/LicenciasEjemplo2.xlsx">archivo</a>.
		</label>
	</div>
</div>

<%@ include file="/WEB-INF/jsp/common/footer2.jsp"%>

