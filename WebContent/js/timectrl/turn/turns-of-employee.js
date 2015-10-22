/**
 * 
 */
function addNew(employeeId) {
	var table = document.getElementById("detailTable"); // $('#detail');
	var row = table.insertRow(-1);
	$(row).hide();

	var currentRow = table.rows.length - 1;

	var cell = row.insertCell(0);
	cell.className = 'cDataTD';
	cell.innerHTML = document.getElementById("TurnsContainer").innerHTML;

	var cell = row.insertCell(1);
	cell.className = 'cDataTD';
	cell.innerHTML = "<input type='text' id='DStartDate'>";
	// cell.innerHTML = "<input type='date' maxlength='10' id='DStartDate'>";

	var cell = row.insertCell(2);
	cell.className = 'cDataTD';
	cell.innerHTML = "<input type='text' maxlength='10' id='DEndDate'>";
	// cell.innerHTML = "<input type='date' maxlength='10' id='DEndDate'>";

	var cell = row.insertCell(3);
	cell.className = 'cDataTD';
	cell.innerHTML = "<button onclick='acceptNew(" + employeeId
			+ ")'>Aceptar</button>" + "<button onclick='cancelAdd("
			+ currentRow + ")'>Cancelar</button>";

	$("#addButton").fadeOut(speed);
	$(row).fadeIn(speed);

	/*
	 * $("#DStartDate").datepicker(); $("#DEndDate").datepicker();
	 */

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
		defaultDate : "+6m",
		changeMonth : true,
		numberOfMonths : 1,
		onSelect : function(selectedDate) {
			$("#DStartDate").datepicker("option", "maxDate", selectedDate);
		}
	});

}


function cancelAdd(index) {
	$("#addButton").fadeIn(speed);

	document.getElementById("detailTable").deleteRow(index);
}

function acceptNew(employee) {
	document.getElementById("Employee").value = employee;
	document.getElementById("Turn").value = document.getElementById("DTurn").value;
	document.getElementById("StartDate").value = document
			.getElementById("DStartDate").value;
	document.getElementById("EndDate").value = document
			.getElementById("DEndDate").value;

	document.getElementById("form").action = contextPath
	// + "/servlet/ShowParameters";
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

function editEmployeeTurn(turnId, startDate, endDate){
	alert(turnId + ' ' + startDate + ' ' + endDate);
	
}