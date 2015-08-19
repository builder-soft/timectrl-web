<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<td class="cLabel">${param["Label"]}:</td>
<td><label class="cLabel"><input type="text"
		name='${param["Name"]}' id='${param["Name"]}'></label></td>


<script type="text/javascript">
	$('#${param["Name"]}').datepicker({
		dateFormat : fixDateFormat(dateFormat),
		appendText : " (" + dateFormat.toLowerCase() + ")",
		defaultDate : "-1m",
		changeMonth : true,
		numberOfMonths : 1
	/*,
	onSelect : function(selectedDate) {
		$("#EndDate").datepicker("option", "minDate", selectedDate);
	}*/
	});
</script>