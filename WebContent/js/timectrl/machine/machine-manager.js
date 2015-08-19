/**
 * 
 */
function onLoadPage() {
	
	return; 
	var table = document.getElementById("MainTable");

	var cell = table.rows[0].insertCell(-1);
	cell.className = "cHeadTD";
	cell.innerHTML = "Marcas";

	cell = table.rows[0].insertCell(-1);
	cell.className = "cHeadTD";
	cell.innerHTML = "Usuarios";

	
}

function fPing() {
	document.getElementById('frm').action = contextPath + "/servlet/timectrl/machine/TestConnection";
	document.getElementById('frm').submit();
}