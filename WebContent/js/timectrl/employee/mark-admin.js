/**
 * 
 */
function resetDate() {
	document.getElementById("Today").value = currentDay;
	document.getElementById("SearchForm").submit();
}

function onLoadPage() {
	$("#Today").datepicker({
		dateFormat : fixDateFormat(dateFormat),
		changeMonth : true,
		numberOfMonths : 1
	});
	$("#Today").datepicker("setDate", today);

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

function showDialog() {
	showTooltip('divShowDetail');
	$("#DateMark").datepicker({
		dateFormat : fixDateFormat(dateFormat),
		changeMonth : true,
		numberOfMonths : 1
	});
	$("#DateMark").datepicker("setDate", currentDay);

}