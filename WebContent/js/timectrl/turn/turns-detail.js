/**
 * Funciones para editar el detalle de los turnos.
 */

function addNew(parentId) {
	var table = document.getElementById("detailTable");
	var row = table.insertRow(-1);
	$(row).hide();

	var currentRow = table.rows.length - 1;
	var col = 0;

	var cell = row.insertCell(col++);
	cell.className = 'cDataTD';
	cell.innerHTML = "<input type='hidden' readonly='true' id='DDay' value='" + currentRow + "'>" + currentRow;

	var cell = row.insertCell(col++);
	cell.className = 'cDataTD';
	cell.innerHTML = "<input type='checkbox' id='DBusinessDay' checked='true' onclick='javascript:changeBusinessDay(this)'>";

	var cell = row.insertCell(col++);
	cell.className = 'cDataTD';
	cell.innerHTML = "<input type='text' maxlength='5' id='DEdgePrevIn' value='0' size='5'>";

	var cell = row.insertCell(col++);
	cell.className = 'cDataTD';
	cell.innerHTML = "<input type='time' maxlength='5' id='DStartTime' value='00:00'>";

	var cell = row.insertCell(col++);
	cell.className = 'cDataTD';
	cell.innerHTML = "<input type='text' maxlength='5' id='DEdgePostIn' value='0' size='5'>";

	var cell = row.insertCell(col++);
	cell.className = 'cDataTD';
	cell.innerHTML = "<input type='text' maxlength='5' id='DEdgePrevOut' value='0' size='5'>";

	var cell = row.insertCell(col++);
	cell.className = 'cDataTD';
	cell.innerHTML = "<input type='time' maxlength='5' id='DEndTime' value='00:00'>";

	var cell = row.insertCell(col++);
	cell.className = 'cDataTD';
	cell.innerHTML = "<input type='text' maxlength='5' id='DEdgePostOut' value='0' size='5'>";

	var cell = row.insertCell(col++);
	cell.className = 'cDataTD';
	cell.innerHTML = "<button onclick='acceptNew(" + parentId + ")'>Aceptar</button>" + "<button onclick='cancelAdd("
			+ currentRow + ")'>Cancelar</button>";

	$("#addButton").fadeOut(speed);
	$(row).fadeIn(speed);
}

function changeBusinessDay(businessDay) {
	var style = "";
	var names = [ "DStartTime", "DEndTime", "DEdgePrevIn", "DEdgePostIn", "DEdgePrevOut", "DEdgePostOut" ];

	if (!businessDay.checked) {
		style = "line-through";
	}

	for (var index in names) {
		document.getElementById(names[index]).disabled = !businessDay.checked;
		document.getElementById(names[index]).style.textDecoration = style;
	}
}

function cancelAdd(index) {
	$("#addButton").fadeIn(speed);

	document.getElementById("detailTable").deleteRow(index);
}

function acceptNew(parentId) {
	document.getElementById("Parent").value = parentId;

	var names = [ "Day", "StartTime", "EndTime", "EdgePrevIn", "EdgePostIn", "EdgePrevOut", "EdgePostOut"];
	for (var index in names) {
		document.getElementById(names[index]).value = document.getElementById("D" + names[index]).value;
	}
	document.getElementById("BusinessDay").value = document.getElementById("DBusinessDay").checked;

	document.getElementById("form").action = contextPath + "/servlet/timectrl/turns/SaveNewHorary";
	document.getElementById("form").submit();
}

function deleteTurnDay(id, rowId, parent) {
	var doIt = confirm("¿Seguro de Borrar el turno del día " + rowId + "?");

	if (doIt) {
		document.getElementById("Parent").value = parent;
		document.getElementById("TurnDay").value = id;

		document.getElementById("form").action = contextPath + "/servlet/timectrl/turns/DeleteTurn";
		document.getElementById("form").submit();
	}
}

function copyDay(turnDay, parent) {
	document.getElementById("Parent").value = parent;
	document.getElementById("TurnDay").value = turnDay;

	document.getElementById("form").action = contextPath + "/servlet/timectrl/turns/CopyTurn";
	document.getElementById("form").submit();
}

function editTurn(id, current){
	$.ajax({
		type : "GET",
		cache : false,
		url : contextPath + '/servlet/timectrl/turns/GetTurnDayAjax',
		data : {
			Id : id,
			currentRow : current
		},
		async : true,
		success : retrieveData,
		error : function(data, textStatus, xhr) {
			alert('Error: ' + xhr);

		}
	});
}

function retrieveData(data){
	var row = document.getElementById("detailTable").rows[data.currentRow];
	alert(row.innerHTML);
	
	
}