function download(){
	if(validate()){
		doSubmit("download");
	}
}

function run(){
	if(validate()){
		doSubmit("run");
	}
}

function doSubmit(action){
	var form = document.getElementById('reportForm');
	form.action += '?' + action;
	form.submit();
}
