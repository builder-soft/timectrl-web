/**
 * 
 */
function checkAll(inputObject) {
	var table = inputObject.parentElement.parentElement.parentElement;
	var input = null;

	for (var i = 1; i < table.rows.length; i++) {
		input = table.rows[i].cells[0].childNodes[0];
		input.checked = inputObject.checked;
	}
}

function changeArea(object) {
	var url = contextPath + "/servlet/timectrl/machine/ListEmployeeByArea?Area=" + object.value;
	$.get(url, insertEmployeesInTable);
}

function insertEmployeesInTable(data, status) {
	var employeeTable = document.getElementById("employeeTable");
	var row = null;
	var cell = null;
	while (employeeTable.rows.length > 1) {
		employeeTable.deleteRow(employeeTable.rows.length - 1);
	}

	for (var i = 0; i < data.length; i++) {
		row = employeeTable.insertRow(-1);

		cell = row.insertCell(-1);
		cell.className = "cDataTD";
		cell.style.textAlign = "center";
		cell.innerHTML = '<input type="checkbox" value="' + data[i].id + '">';

		cell = row.insertCell(-1);
		cell.className = "cDataTD";
		cell.innerHTML = data[i].key;

		cell = row.insertCell(-1);
		cell.className = "cDataTD";
		cell.innerHTML = data[i].name;
/*
		cell = row.insertCell(-1);
		cell.className = "cDataTD";
		cell.style.textAlign = "center";
		cell.innerHTML = data[i].enabled == "true" ? "Si" : "No";

		cell = row.insertCell(-1);
		cell.className = "cDataTD";
		cell.style.textAlign = "center";
		cell.innerHTML = data[i].privilege;
*/
		cell = row.insertCell(-1);
		cell.className = "cDataTD";
		cell.style.textAlign = "center";
		cell.innerHTML = data[i].fingerprint == "true" ? "Si" : "No";

	}

}

function syncUserinfo() {
	runMassiveAction("MachineUsers", "/servlet/timectrl/machine/SyncUserinfo");
/**	var formObject = document.getElementById("MachineUsers");
	formObject.action = contextPath + "/servlet/timectrl/machine/SyncUserinfo";
	formObject.submit();*/
}

function addEmployee(){
	runMassiveAction("DatabaseUser", "/servlet/timectrl/machine/AddEmployee");
/**	var formObject = document.getElementById("DatabaseUser");
	formObject.action = contextPath + "/servlet/timectrl/machine/AddEmployee";
	formObject.submit();*/
}

function deleteEmployees(){
	runMassiveAction("MachineUsers", "/servlet/timectrl/machine/DeleteEmployee");
	/**
	var formObject = document.getElementById("MachineUsers");
	formObject.action = contextPath + "/servlet/timectrl/machine/DeleteEmployee";
	formObject.submit();
	*/
}

function runMassiveAction(formId, url){
	var formObject = document.getElementById(formId);
	formObject.action = contextPath + url;
	formObject.submit();
}