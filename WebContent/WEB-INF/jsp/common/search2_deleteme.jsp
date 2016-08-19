<%@page import="cl.buildersoft.framework.util.crud.BSTableConfig"%>
<div class="row">
	<div class="col-md-4 col-md-offset-8">
		<div class="input-group">
			<!-- Busqueda:--><%=write_input_field_for_search(request)%>

			<span class="input-group-btn">
				<button class="btn btn-default" type="button"
					onclick="javascript:go();">
					<span class="glyphicon glyphicon-search" aria-hidden="true"></span>
				</button>

				<button class="btn btn-default" type="button"
					onclick="javascript:clearGo();">
					<span class="glyphicon glyphicon-remove" aria-hidden="true"></span>
				</button>
			</span>
		</div>
	</div>
</div>
<script type="text/javascript">
function onLoadPage(){
	$("#Search").keypress(function(event){
		if(event.keyCode==13){
			go();
		}
	});
}

function clearGo(){
	$("#Search").val('');
	go();
}

function go(){
	var url = "<%=_return_path_context(request)%>" +
	 "?Search=" + $('#Search').val() + "&Page=" + $("#CurrentPage").val();
		self.location.href = url;
	}
//-->
</script>

<%!private String _return_path_context(HttpServletRequest request) {
		BSTableConfig table = (BSTableConfig) request.getSession(false)
				.getAttribute("BSTable");
		String uri = table.getUri();
		String ctxPath = request.getContextPath();
		String out = ctxPath + uri;

		return out;
	}

	private String write_input_field_for_search(HttpServletRequest request) {
		String out = "<input name='Search' class='form-control' id='Search' size='30' maxlength='50' type='search' placeholder='Busqueda...' value='"
				+ request.getAttribute("Search") + "'>";
		return out;
	}%>