<%@page import="cl.buildersoft.framework.beans.BSTableConfig"%>
<div align="right" width="100%" class="cLabel">

	<!-- Busqueda:--><%=write_input_field_for_search(request)%>

</div>
<script type="text/javascript">
 
$("#Search").keypress(function(event){
	if(event.keyCode==13){
		var url = "<%=_return_path_context(request)%>" + "?Search=" + $('#Search').val() + "&Page=" + $("#CurrentPage").val();
//		alert(url);		
		self.location.href = url;
	}
});

//-->
</script>

<%!private String _return_path_context(HttpServletRequest request) {
		BSTableConfig table = (BSTableConfig) request.getSession().getAttribute("BSTable");
		String uri = table.getUri();
		String ctxPath = request.getContextPath();
		String out = ctxPath + uri;

		return out;
	}

	private String write_input_field_for_search(HttpServletRequest request) {
		String out = "<input name='Search' id='Search' size='30' maxlength='50' type='search' placeholder='Busqueda...' value='"
				+ request.getAttribute("Search") + "'>";
		return out;
	}%>