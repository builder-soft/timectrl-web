<%@page import="cl.buildersoft.framework.dataType.BSDataType"%>
<%@page import="cl.buildersoft.framework.dataType.BSDataTypeEnum"%>
<%@page import="cl.buildersoft.framework.util.crud.BSField"%>
<%@page import="java.util.List"%>
<%@page import="java.io.PrintWriter"%>

<%!private String getAlign(BSField field) {
		BSDataType type = field.getType();
		String out = " align='left' ";

		if (type.isTime() || type.getDataTypeEnum().equals(BSDataTypeEnum.BOOLEAN) || field.isFK()) {
			out = " align='center' ";
		} else if (type.isNumber()) {
			out = " align='right' ";
		}

		 
		return out;
	}


	private String capitalize(String s) {
		return s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase();
	}
	 %>