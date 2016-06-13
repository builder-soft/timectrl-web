function onLoadPage(){
	//toggleException(exception);
	/**
	<li <%=exception?"class='active'":""%>><a data-toggle="tab" href="#exception"
		onclick="javascript:toggleException(true)">Excepcionales</a></li>
		*/
}

function toggleException(status) {
	document.getElementById("Exception").value = status;
}

function addNew(employeeId) {
	var table = getTable();

	var row = table.insertRow(-1);
	$(row).hide();

	var currentRow = table.rows.length - 1;

	var cell = row.insertCell(0);
	cell.className = 'cDataTD';
	cell.innerHTML = document.getElementById("TurnsContainer").innerHTML;

	cell = row.insertCell(1);
	cell.className = 'cDataTD';
	cell.innerHTML = "<input type='text' id='DStartDate'>";

	cell = row.insertCell(2);
	cell.className = 'cDataTD';
	cell.innerHTML = "<input type='text' maxlength='10' id='DEndDate'>";

	cell = row.insertCell(3);
	cell.className = 'cDataTD';
	cell.innerHTML = "<button onclick='acceptNew(" + employeeId
			+ ")'>Aceptar</button>" + "<button onclick='cancelAdd("
			+ currentRow + ")'>Cancelar</button>";

	$("#addButton").fadeOut(speed);
	$(row).fadeIn(speed);

	convertToDatePicker();
}

function getTable() {
	return document.getElementById(ifExceptionSelected() ? "exceptionTable"
			: "detailTable");
}

function ifExceptionSelected() {
	return document.getElementById("Exception").value == "true";
}

function convertToDatePicker() {
	$("#DStartDate").datepicker({
		dateFormat : fixDateFormat(dateFormat),
		appendText : " (" + dateFormat.toLowerCase() + ")",
		defaultDate : "-1m",
		changeMonth : true,
		numberOfMonths : 3,
		onSelect : function(selectedDate) {
			$("#DEndDate").datepicker("option", "minDate", selectedDate);
		}
	});
	$("#DEndDate").datepicker({
		dateFormat : fixDateFormat(dateFormat),
		appendText : " (" + dateFormat.toLowerCase() + ")",
		defaultDate : ifExceptionSelected() ? "+0m" : "+6m",
		changeMonth : true,
		numberOfMonths : 1,
		onSelect : function(selectedDate) {
			$("#DStartDate").datepicker("option", "maxDate", selectedDate);
		}
	});

}

function cancelAdd(index) {
	$("#addButton").fadeIn(speed);

	getTable().deleteRow(index);
}

function acceptNew(employee) {
	document.getElementById("Employee").value = employee;
	document.getElementById("Turn").value = document.getElementById("DTurn").value;
	document.getElementById("StartDate").value = document
			.getElementById("DStartDate").value;
	document.getElementById("EndDate").value = document
			.getElementById("DEndDate").value;

	document.getElementById("form").action = contextPath
			+ "/servlet/timectrl/employee/SaveNewTurn";
	document.getElementById("form").submit();
}

function deleteEmployeeTurn(id, employeeId, employeeName) {
	var doIt = confirm("¿Seguro de Borrar el horario para " + employeeName
			+ "?");

	if (doIt) {
		document.getElementById("EmployeeTurn").value = id;
		document.getElementById("Employee").value = employeeId;

		document.getElementById("form").action = contextPath
				+ "/servlet/timectrl/employee/DeleteEmployeeTurn";
		document.getElementById("form").submit();
	}
}

function editEmployeeTurn(button, turnId, turn, startDate, endDate, employeeId) {
	var row = $(button).parent().parent();

	row.find("td:first").html(
			document.getElementById("TurnsContainer").innerHTML);
	row.find("td:eq(1)").html("<input type='text' id='DStartDate'>");
	row.find("td:eq(2)").html(
			"<input type='text' maxlength='10' id='DEndDate'>");
	row.find("td:eq(3)").html(
			"<button onclick='acceptEdit(" + turnId + "," + employeeId
					+ ")'>Aceptar</button>" + "<button onclick='cancelEdit("
					+ employeeId + ")'>Cancelar</button>");

	convertToDatePicker();

	$("#DStartDate").datepicker('setDate', startDate);
	$("#DEndDate").datepicker('setDate', endDate);

	$('#DTurn').val(turn);
}

function acceptEdit(id, employeeId) {
	document.getElementById("Employee").value = employeeId;
	document.getElementById("TurnId").value = id;
	document.getElementById("Turn").value = document.getElementById("DTurn").value;
	document.getElementById("StartDate").value = document
			.getElementById("DStartDate").value;
	document.getElementById("EndDate").value = document
			.getElementById("DEndDate").value;

	document.getElementById("form").action = contextPath
			+ "/servlet/timectrl/employee/SaveNewTurn";
	document.getElementById("form").submit();

}

function cancelEdit(employeeId) {
	document.getElementById("cId").value = employeeId;
	document.getElementById("form").action = contextPath
			+ "/servlet/timectrl/employee/TurnsOfEmployee";
	document.getElementById("form").submit();
}