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
	cell.innerHTML = "<input type='hidden' readonly='true' id='DDay' value='"
			+ currentRow + "'>" + currentRow;

	cell = row.insertCell(col++);
	cell.innerHTML = "<input type='checkbox' id='DBusinessDay' checked='true' onclick='javascript:changeBusinessDay(this)'>";

	cell = row.insertCell(col++);
	cell.innerHTML = "<input type='number' min='0' max='60' maxlength='5' id='DEdgePrevIn' value='0' size='5'>";

	cell = row.insertCell(col++);
	cell.innerHTML = "<input type='time' maxlength='5' id='DStartTime' value='00:00'>";

	cell = row.insertCell(col++);
	cell.innerHTML = "<input type='number' min='0' max='60' maxlength='5' id='DEdgePostIn' value='0' size='5'>";

	cell = row.insertCell(col++);
	cell.innerHTML = "<input type='number' min='0' max='60' maxlength='5' id='DEdgePrevOut' value='0' size='5'>";

	cell = row.insertCell(col++);
	cell.innerHTML = "<input type='time' maxlength='5' id='DEndTime' value='00:00'>";

	cell = row.insertCell(col++);
	cell.innerHTML = "<input type='number' min='0' max='60' maxlength='5' id='DEdgePostOut' value='0' size='5'>";

	cell = row.insertCell(col++);
	cell.innerHTML = "<button class='btn btn-primary' onclick='acceptNew(" + parentId
			+ ")'>Aceptar</button>" + "<button class='btn btn-link' onclick='cancelAdd("
			+ currentRow + ")'>Cancelar</button>";

	$("#addButton").fadeOut(speed);
	$(row).fadeIn(speed);
}

function changeBusinessDay(businessDay) {
	var style = "";
	var names = [ "DStartTime", "DEndTime", "DEdgePrevIn", "DEdgePostIn",
			"DEdgePrevOut", "DEdgePostOut" ];

	if (!businessDay.checked) {
		style = "line-through";
	}

	for ( var index in names) {
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

	var names = [ "Day", "StartTime", "EndTime", "EdgePrevIn", "EdgePostIn",
			"EdgePrevOut", "EdgePostOut" ];
	for ( var index in names) {
		document.getElementById(names[index]).value = document
				.getElementById("D" + names[index]).value;
	}
	document.getElementById("BusinessDay").value = document
			.getElementById("DBusinessDay").checked;

	document.getElementById("form").action = contextPath
			+ "/servlet/timectrl/turns/SaveNewHorary";
	document.getElementById("form").submit();
}

function deleteTurnDay(id, rowId, parent) {
	var doIt = confirm("¿Seguro de Borrar el turno del día " + rowId + "?");

	if (doIt) {
		document.getElementById("Parent").value = parent;
		document.getElementById("TurnDay").value = id;

		document.getElementById("form").action = contextPath
				+ "/servlet/timectrl/turns/DeleteTurn";
		document.getElementById("form").submit();
	}
}

function copyDay(turnDay, parent) {
	document.getElementById("Parent").value = parent;
	document.getElementById("TurnDay").value = turnDay;

	document.getElementById("form").action = contextPath
			+ "/servlet/timectrl/turns/CopyTurn";
	document.getElementById("form").submit();
}

function editTurn(id, current) {
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

function retrieveData(data) {
	var row = document.getElementById("detailTable").rows[data.currentRow];

	removeCells(row);
	createCells(row);

	row.cells[0].innerHTML = "<input type='hidden' readonly='true' id='DDay' value='"
			+ data.currentRow + "'>" + data.currentRow;
	;
	row.cells[1].innerHTML = "<input type='checkbox' id='DBusinessDay' "
			+ (data.businessDay == "true" ? "checked" : "")
			+ " onclick='javascript:changeBusinessDay(this)'>";
	row.cells[2].innerHTML = "<input type='text' maxlength='5' id='DEdgePrevIn' value='0' size='5' value='"
			+ data.edgePrevIn + "'>";
	row.cells[3].innerHTML = "<input type='time' maxlength='5' id='DStartTime' value='"
			+ data.startTime + "'>";
	row.cells[4].innerHTML = "";
}

function createCells(row) {
	for ( var i = 0; i < 9; i++) {
		row.insertCell(i).className = 'cDataTD';
	}
}

function removeCells(row) {
	while (row.cells.length > 0) {
		row.deleteCell(0);
	}
}