function onLoadPage() {
	// var person = {fname:"John", lname:"Doe", age:25};

	// var text = "";
	//var i = 0;
	for (var i in paramList) {
		// alert(paramList[i].name);
		if (paramList[i].type == '2') {
			setupCalendar(paramList[i].name);
		}
	}
	/*
	 * paramList setupCalendar("");
	 */
}

function setupCalendar(inputId) {
	$("#" + inputId).datepicker({
		dateFormat : fixDateFormat(dateFormat),
		defaultDate : "-1m",
		appendText : " (" + dateFormat.toLowerCase() + ")",
		changeMonth : true,
		numberOfMonths : 1
	});

}