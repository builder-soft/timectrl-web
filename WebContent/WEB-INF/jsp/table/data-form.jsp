<%@page import="cl.buildersoft.framework.util.BSDateTimeUtil"%>
<%@page import="cl.buildersoft.framework.beans.BSCss"%>
<%@page import="cl.buildersoft.framework.beans.BSScript"%>
<%@page import="cl.buildersoft.framework.beans.BSHeadConfig"%>
<%@page import="cl.buildersoft.framework.util.BSWeb"%>
<%@page import="cl.buildersoft.framework.type.BSFieldType"%>
<%@page import="cl.buildersoft.framework.beans.BSField"%>
<%@page import="cl.buildersoft.framework.beans.BSTableConfig"%>
<%@page import="java.sql.ResultSet"%>
<%
	BSTableConfig table = (BSTableConfig) session.getAttribute("BSTable");
//Connection conn = (Connection) request.getAttribute("Conn");

BSField[] fields = table.getFields();
%>
<%@ include file="/WEB-INF/jsp/common/header.jsp"%>
<%
	BSHeadConfig head = (BSHeadConfig) session.getAttribute("BSHead");
	if (head != null) {
		BSScript script = head.getScript();
		BSCss css = head.getCss();
		for (String oneScript : script.getListScriptNames()) {
	out.print("<script src='" + request.getContextPath() + script.getPath() + oneScript + ".js'></script>");
		}

		for (String oneCss : css.getListCssNames()) {
	out.print("<LINK rel='stylesheet' type='text/css' src='" + request.getContextPath() + css.getPath() + oneCss
	+ ".css'/>");
		}
	}
%>
<script type="text/javascript">
function onLoadPage(){
	<%
	String fieldName=null;
	String html = "";
	BSFieldType type=null;
	String typeHtml = null;
	Boolean showThis = null;
	
	for (BSField field : fields) {
		type = field.getType();
		fieldName = field.getName();
		typeHtml = field.getTypeHtml();
		showThis = field.isReadonly();
		
		if(type.equals(BSFieldType.Date)){
			%>
			$("#<%=fieldName%>").datepicker({
					dateFormat : fixDateFormat(dateFormat)
				});
			<%
		}
	}
	%>
	
	}

	function sendForm() {
		var msg = null;
<%
	
	for (BSField field : fields) {
		type = field.getType();
		fieldName = field.getName();
		typeHtml = field.getTypeHtml();
		showThis = field.isReadonly();
		html = "";

		if(!showThis){
			if(type.equals(BSFieldType.Double) || type.equals(BSFieldType.Integer)|| type.equals(BSFieldType.Date)|| "email".equalsIgnoreCase(typeHtml)) {
				if(type.equals(BSFieldType.Double)){
					html = "var " + fieldName + " = formated2double(document.getElementById('"+fieldName+"').value);\n";
				}
				if(type.equals(BSFieldType.Integer)){
					html = "var " + fieldName + " = formated2integer(document.getElementById('"+fieldName+"').value);\n";
				}
				/**
				if(type.equals(BSFieldType.Date)){
					html = "var " + fieldName + " = isDate(document.getElementById('"+fieldName+"').value);\n";
					html += fieldName + " = " + fieldName +"?"+fieldName +":null;\n";
				}
				*/
				if(field.getTypeHtml().equalsIgnoreCase("email")){
					html = "var " + fieldName + " = isEmail(document.getElementById('"+fieldName+"').value);\n";
					html += fieldName + " = " + fieldName +"?"+fieldName +":null;\n";
				}
	
				html += "if (" + fieldName + " == null) {\n";
				html += "   msg = 'El campo \"" + field.getLabel() + "\" no es valido';\n";
				html += "}\n";
			}
		}%>
	
<%=html%>
	
<%}%>
	if (msg != null) {
			alert(msg);
		} else {
<%
			html = "";
			for (BSField field : fields) {
					type = field.getType();
					fieldName = field.getName();
					showThis = field.isReadonly();
					
					if(!showThis) {
						if (type.equals(BSFieldType.Double) || type.equals(BSFieldType.Integer)) {
							html += "document.getElementById('" + fieldName + "').value = " + fieldName + ";\n";
						}
					}%>
	
<%		}%>
	
<%=html%>
	document.getElementById("editForm").submit();
		}
	}
</script>
<%@ include file="/WEB-INF/jsp/common/menu.jsp"%>
<h1 class="cTitle">Detalle de información</h1>
<%
	String nextServlet = (String) request.getAttribute("Action");
	if ("insert".equalsIgnoreCase(nextServlet) || table.usingView()) {
		nextServlet = "InsertRecord";
	} else {
		nextServlet = "UpdateRecord";
	}
%>

<form
	action="${pageContext.request.contextPath}/servlet/common/<%=nextServlet%>"
	method="post" id="editForm">
	<table>
		<%
			Boolean readOnly=null;
			for (BSField field : fields) {
				readOnly = field.isReadonly();
				if(!readOnly) {
		%>
				<tr>
					<td class="cLabel" valign='top'><%=field.getLabel()%>:</td>
					<td><%=writeHTMLField(field, request)%></td>
				</tr>
		<%
				}
			}
		%>
	</table>
</form>
<button type="button" onclick="javascript:sendForm()">Aceptar</button>
&nbsp;&nbsp;&nbsp;
<a class="cCancel"
	href="${pageContext.request.contextPath}/servlet/common/LoadTable">Cancelar</a>


<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>

<%!private static String NEW = "[Nuevo]";

	private String writeHTMLField(BSField field, HttpServletRequest request) {
		String out = "";
		BSFieldType type = field.getType();
		Object value = field.getValue();
		Integer maxlength = 0;
		String name = field.getName();
		String format = "";
		Integer size = 0;
		String afterInput = "";
		Boolean isPk = field.isPK();
		//Boolean isNew = Boolean.FALSE;
		Boolean isReadOnly = isPk ? Boolean.TRUE : field.isReadonly();
		String validationOnBlur = field.getValidationOnBlur() != null ? field.getValidationOnBlur() : "";

		if (isFK(field)) {
			out += getFKSelect(field);
		} else {
			if (type.equals(BSFieldType.Boolean)) {
				out += "<SELECT name='" + name + "' ";
				out += isReadOnly ? " DISABLED " : "";
				out += ">";

				out += writeOptionHTML("true", "Si", value);
				out += writeOptionHTML("false", "No", value);

				out += "</SELECT>";
			} else {
				if (type.equals(BSFieldType.String)) {
					value = value == null ? "" : value;
					maxlength = field.getLength();
					size = maxlength;
					if (size > 75) {
						size = 75;
					}
				} else if (type.equals(BSFieldType.Date)) {
					maxlength = 10;
					format = BSDateTimeUtil.getFormatDate(request);
					value = BSDateTimeUtil.date2String(value, format);
					size = maxlength;
					afterInput = "(formato: " + format + ")";
type = BSFieldType.Text;
				} else if (type.equals(BSFieldType.Timestamp)) {
					maxlength = 16;
					format = BSDateTimeUtil.getFormatDatetime(request);
					value = BSDateTimeUtil.date2String(value, format);
					size = maxlength;
					afterInput = "(formato: " + format + ")";
type = BSFieldType.Text;
				} else if (type.equals(BSFieldType.Double)) {
					maxlength = 15;
					value = BSWeb.formatDouble(request, (Double) value);
					size = maxlength;
				} else if (type.equals(BSFieldType.Integer)) {
					maxlength = 8;
					value = BSWeb.formatInteger(request, (Integer) value);
					size = maxlength;
				} else if (type.equals(BSFieldType.Long)) {
					maxlength = 10;
					if (isPk && value == null) {
						value = NEW;
					} else {
						value = value == null ? "" : BSWeb.formatLong(request, (Long) value);
					}
					size = maxlength;
				}

				out += drawInputText(field.getTypeHtml(), name, maxlength, isReadOnly, value, size, afterInput, validationOnBlur,
						isPk, type);
			}
		}
		return out;
	}

	private String writeOptionHTML(String option, String display, Object value) {
		String out = "<OPTION value='" + option + "'";
		out += (value != null && value.toString().equals(option) ? " selected" : "");
		out += ">" + display + "</OPTION>";
		return out;
	}

	private Boolean isFK(BSField field) {
		Boolean out = Boolean.FALSE;
		List<Object[]> data = field.getFKData();
		out = data != null;
		return out;
	}

	private String drawInputText(String type, String name, Integer maxlength, Boolean isReadonly, Object value, Integer size,
			String afterInput, String validationOnBlur, Boolean isPk, BSFieldType dataType) {
		String out = "";

		if (isPk) {
			out += "<span class='cData'>" + value + "</span>";
			type = isPk ? "hidden" : type;
		}

		if(type.equals(BSFieldType.Date) || type.equals(BSFieldType.Timestamp)){
			out += "$('#" + name + "').datepicker({	dateFormat : fixDateFormat(dateFormat)});\n";
			out += "$('#" + name + "').datepicker('setDate', value);\n";
		} else {		
			out += "<input type='" + type + "' name='";
			out += name;
			out += "' ";
			out += "id='" + name + "' ";
			out += "maxlength='" + maxlength + "' ";
			out += isReadonly ? "READONLY " : "";
			out += "value='" + (value.equals(NEW) ? "0" : value) + "' ";
			out += "size='" + size + "px' ";
	
			out += addScript(dataType, type);
		}
		if (!"".equals(validationOnBlur)) {
			out += "onBlur='javascript:" + validationOnBlur + "(this)'";
		}

		out += ">&nbsp;<span class='cLabel'>" + afterInput + "</span>";

		return out;
	}

	private String addScript(BSFieldType dataType, String type) {
		String out = "";
		if (dataType.equals(BSFieldType.Double)) {
			out = "onfocus='javascript:doubleFocus(this);' ";
			out += "onblur='javascript:doubleBlur(this);' ";
		} else if (dataType.equals(BSFieldType.Integer)) {
			out = "onfocus='javascript:integerFocus(this);' ";
			out += "onblur='javascript:integerBlur(this);' ";
		} else if (dataType.equals(BSFieldType.Date)) {
			out += "onblur='javascript:dateBlur(this);' ";
		} else {
			if (type.equalsIgnoreCase("email")) {
				out += "onblur='javascript:emailBlur(this);' ";
			}
		}
		return out;
	}

	private String getFKSelect(BSField field) {
		String name = field.getName();
		Object value = field.getValue();
		Boolean isNullable = field.getIsNullable();

		String out = "<select name='";
		out += name + "'>";
		if(isNullable){
			out+="<option value=''>- Ninguno -</option>";
		}		
		List<Object[]> data = field.getFKData();
		for (Object[] row : data) {
			out += "<option value='" + row[0] + "' ";
			if (value != null) {
				out += value.equals(row[0]) ? " selected " : "";
			}
			out += ">" + row[1] + "</option>";
		}
		out += "</select>";
		return out;
	}%>
