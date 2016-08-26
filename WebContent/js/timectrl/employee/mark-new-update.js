/**
 * 
 */
function onLoadPage() {	
	
	$("#DateMark").datepicker({
		dateFormat : fixDateFormat(dateFormat),
		changeMonth : true,
		numberOfMonths : 1
	});
	$("#DateMark").datepicker("setDate", dateMark);
	
}


function saveNewMark() {
	// alert('saveNewMark');
	var dateTimeMark = document.getElementById("DateMark").value + ' '
			+ document.getElementById("HH").value + ':'
			+ document.getElementById("MM").value + ':'
			+ document.getElementById("SS").value;

	document.getElementById("DateTimeMark").value = dateTimeMark;
	document.getElementById("SaveForm").submit();
}
