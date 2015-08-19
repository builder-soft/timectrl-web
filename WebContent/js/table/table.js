function swapAllCheck(obj) {
	var elements = $('input:checkbox');
	elements.each(swap);

	verifyButtons();
}

function swapCheck(obj) {
	verifyButtons();
}

function verifyButtons() {
	var elementsSelected = $("input:checked");

	if (elementsSelected.size() == 1
			&& 'mainCheck' == elementsSelected.get(0).id) {
		$("#MultirecordActions").fadeOut(speed);
		$("#RecordActions").fadeOut(speed);
	} else {
		if (elementsSelected.size() == 0) {
			$("#RecordActions").fadeOut(speed);
			$("#MultirecordActions").fadeOut(speed);
		} else {
			if (elementsSelected.size() == 1) {
				$("#RecordActions").fadeIn(speed);
			} else {
				$("#RecordActions").fadeOut(speed);
			}
			$("#MultirecordActions").fadeIn(speed);
		}
	}
}

function swap(i, o) {
	var checked = $('#mainCheck').prop("checked");
	if (i > 0) {
		$(o).attr('checked', checked);
	}
}

function fDelete() {
	var elements = $("input:checked");
	var mainChecked = $('#mainCheck').prop("checked");
	var count = elements.size();

	var elementoString = elements.size() == 1 ? ' elemento' : ' elementos';
	if (confirm('¿Esta seguro de querer borrar ' + elements.size()
			+ elementoString + '?')) {
		$('#frm').submit();
	}
}

function doAction(url, actionCode) {
	$('#frm').prop("action", url + "?CodeAction=" + actionCode);
	$('#frm').submit();
}