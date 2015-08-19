var showdButtons = false;

function onLoadPage() {

}

function selectRow() {
	if (!showdButtons) {
		$("#ModifyParam").fadeIn(speed);
		$("#DeleteParam").fadeIn(speed);
		showdButtons = true;
	}
}

function newParameter() {
	showTooltip("divShowDetail");
	changeInputType(document.getElementById("FromUser"));
}

function commitNewRecord() {
	/**
	 * <code>
	var form = document.getElementById("formData");
	form.action = contextPath + "/servlet/ShowParameters";
	form.action = contextPath + "/servlet/timectrl/report/config/InConfigSave";
	form.submit();
	</code>
	 */
	commit("/servlet/timectrl/report/config/SaveParameterValue");
}

function commit(url) {
	var form = document.getElementById("formData");
	//form.action = contextPath + "/servlet/ShowParameters";
	form.action = contextPath + url;
	// /servlet/timectrl/report/config/InConfigSave
	form.submit();
}

function deleteRecord() {
	// alert(document.getElementById(""));
	var params = document.getElementsByName('ParamListId');
	var id = getIdSelected(params);

	document.getElementById("ParamId").value = id;
//alert(id);
	if(confirm('Esta Seguro de eliminar el registro?')){ 
		commit("/servlet/timectrl/report/config/DeleteParameterValue");
	}
	// alert(id);
}

function getIdSelected(params) {
	var id = null;
	for ( var i = 0; i < params.length; i++) {
		if (params[i].checked) {
			id = params[i].value;
			break;
		}
	}
	return id;
}

function changeInputType(inputUser) {
	// var inputUserBoolean = (inputUser.value == 'true');
	// alert(document.getElementById("Value").id);
	if (inputUser.value == 'true') {
		$("#ValueRow").fadeOut(speed);
	} else {
		$("#ValueRow").fadeIn(speed);
	}
	// document.getElementById("Value").disabled = inputUserBoolean;

	// alert(inputUser.value);
}