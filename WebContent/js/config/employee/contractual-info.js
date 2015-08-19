function validateAndSubmit() {
	var feeding = formated2double(document.getElementById("cFeeding").value);
	var mobilization = formated2double(document.getElementById("cMobilization").value);
	var salaryRoot = formated2integer(document.getElementById("cSalaryRoot").value);
	var starContract = isDate(document.getElementById("cStartContract").value);

	var msg = null;
	if (feeding == null) {
		msg = "El campo Colacion no es valido";
	}
	if (mobilization == null) {
		msg = "El campo Movilizacion no es valido";
	}
	if (salaryRoot == null) {
		msg = "El Sueldo base no es valido";
	}
	if (!starContract) {
		msg = "La fecha de inicio de contrato no corresponde";
	}
	
	if (msg != null) {
		alert(msg);
	} else {
		document.getElementById("cFeeding").value = feeding;
		document.getElementById("cMobilization").value = mobilization;
		document.getElementById("cSalaryRoot").value = salaryRoot;

		document.getElementById("frmContractualInfo").submit();
	}

}