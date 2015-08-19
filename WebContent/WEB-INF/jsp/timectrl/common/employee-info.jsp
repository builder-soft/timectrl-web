<table border="0" width="80%">
	<tr>
		<td class="cLabel" valign="top">Lleve:</td>
		<td class="cData" valign="top">${requestScope.Employee.key}</td>
		<td class="cLabel">RUT:</td>
		<td class="cData">${requestScope.Employee.rut}</td>
		<td class="cLabel">Nombre:</td>
		<td class="cData">${requestScope.Employee.name}</td>
	</tr>
	<tr>
		<td class="cLabel">Cargo:</td>
		<td class="cData">${requestScope.Post.name}</td>
		<td class="cLabel">Área:</td>
		<td class="cData">${requestScope.Area.name}</td>
		<td class="cData" colspan="2"></td>
	</tr>
</table>