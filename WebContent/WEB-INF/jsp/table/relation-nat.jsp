<%@page import="cl.buildersoft.framework.util.crud.BSField"%>
<%@page import="cl.buildersoft.framework.util.crud.BSTableConfig"%>
<%@page import="java.sql.Connection"%>
<%@page import="cl.buildersoft.framework.database.BSmySQL"%>
 
<%@page import="java.util.Arrays"%>
<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.util.ArrayList"%>
 
<%@page import="java.sql.ResultSet"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>
<%
	String ctxPath = request.getContextPath();
	ResultSet relation = (ResultSet) request.getAttribute("Relation");
	ResultSet list = (ResultSet) request.getAttribute("List");
	Connection conn = (Connection) request.getAttribute("Conn");

	BSTableConfig table = (BSTableConfig) session.getAttribute("BSTable");
	BSField[] fields = table.getFields();

	BSmySQL mysql = new BSmySQL();
	List<Object[]> listArray = mysql.resultSet2Matrix(list);
	list.close();

	List<Object[]> relationArray = mysql.resultSet2Matrix(relation);
	relation.close();
	
	new BSmySQL().closeConnection(conn);

%>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/table/relation.js?<%=BSWeb.randomString()%>"></script>

<h1 class="cTitle"><%=table.getTitle()%></h1>

<!-- 
<table>
	<%for (BSField field : fields) {%>
	<tr>
		<td class="cLabel" valign='top'><%=field.getLabel()%>:</td>
		<td class="cData"><%=field.getValue()%></td>
	</tr>
	<%}%>
</table>
 -->
<!--
action="${pageContext.request.contextPath}/servlet/ShowParameters"
action="${pageContext.request.contextPath}/servlet/common/SaveRelation"
  -->
<form
	action="${pageContext.request.contextPath}/servlet/common/SaveRelation"
	id="frm" method="post">
	<input type="hidden" name="cId"
		value="<%=request.getParameter("cId")%>"> <input type="hidden"
		name="CodeAction" value="<%=request.getParameter("CodeAction")%>">

	<table border="0" width="50%">
		<tr>
			<td style="width: 30%" align="center"><span class="cLabel">Disponibles</span><br>
				<select SIZE="10" id="left" style="width: 100%">
					<%
						for (Object[] row : listArray) {
							if (!exists(row, relationArray)) {
					%>
					<option value="<%=row[0]%>"><%=row[1]%></option>
					<%
						}
						}
					%>
			</select></td>

			<td style="width: 10%" align="center"><button type="button"
					onclick="javascript:moveToRight();" style="width: 100%">-></button> <br>
				<br> <br>
				<button type="button" onclick="javascript:moveToLeft();"
					style="width: 100%"><-</button></td>

			<td style="width: 30%" align="center"><span class="cLabel"
				align="center">Seleccionados</span><br> <select name="Relation"
				SIZE="10" id="right" style="width: 100%">
					<%
						for (Object[] row : relationArray) {
					%>
					<option value="<%=row[0]%>"><%=row[1]%></option>
					<%
						}
					%>
			</select></td>
		</tr>
		<tr>
			<td align="center"><button type="button"
					onclick="javascript:save();">Aceptar</button></td>
			<td>&nbsp;</td>
			<td align="center"><a class="cCancel"
				href="<%=ctxPath + table.getUri()%>">Cancelar</a></td>
		</tr>
	</table>
</form>
<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>

<%!/**<code>
	 private List<String[]> resultSet2Matrix(ResultSet rs) {
	 List<String[]> out = new ArrayList<String[]>();
	
	 Integer i = 0;
	 ResultSetMetaData metaData = rs.getMetaData();
	 Integer colCount = metaData.getColumnCount();
	 String[] colNames = new String[colCount];
	 for (i = 1; i <= colCount; i++) {
	 colNames[i - 1] = metaData.getColumnName(i);
	 }

	 String[] innerArray = null;
	 while (rs.next()) {
	 i = 0;
	 innerArray = new String[colCount];
	 for (String colName : colNames) {
	 innerArray[i] = rs.getString(colName);
	 i++;
	 }
	 out.add(innerArray);
	 }
	
	 return out;
	 }
	 </code>*/

	private Boolean exists(Object[] element, List<Object[]> list) {
		Boolean out = Boolean.FALSE;
		for (Object[] e : list) {
			//showCompares(element, e);

			if (Arrays.equals(element, e)) {
				//			if (element.toString().equals(e.toString())) {
				out = Boolean.TRUE;
				break;
			}
		}
		/*
		System.out.println(Arrays.toString(element) + "in" + showList(list)
			+ "->" + out);
		 */
		return out;
	}

	private void showCompares(Object[] a, Object[] b) {
		System.out.println(Arrays.toString(a) + " == " + Arrays.toString(b) + "->" + Arrays.equals(a, b));
	}

	private String showList(List<Object[]> l) {
		String out = "";

		for (Object[] e : l) {
			out += Arrays.toString(e) + ", ";
		}
		return out;
	}%>