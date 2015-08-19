function saveValues() {
	var table = document.getElementById("tableValues");
	var row = null;
	var id = null;
	var value = null;
	
//	alert(table.rows.length);
	for (var i = 0; i < table.rows.length; i++) {
		row = table.rows[i];
		id = row.cells[0].innerHTML;
		value = row.cells[2].innerHTML;
		alert(id + " - " + value);
	}
	
	
}