function onLoadPage(){
	$("#StartDate").datepicker({
		dateFormat : fixDateFormat(dateFormat),
		appendText : " (" + dateFormat.toLowerCase() + ")",
		defaultDate : "-1m",
		changeMonth : true,
		numberOfMonths : 3,
		onSelect : function(selectedDate) {
			$("#EndDate").datepicker("option", "minDate", selectedDate);
		}
	});
	$("#EndDate").datepicker({
		dateFormat : fixDateFormat(dateFormat),
		appendText : " (" + dateFormat.toLowerCase() + ")",
		defaultDate : "+0d",
		changeMonth : true,
		numberOfMonths : 1,
		onSelect : function(selectedDate) {
			$("#StartDate").datepicker("option", "maxDate", selectedDate);
		}
	});

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
