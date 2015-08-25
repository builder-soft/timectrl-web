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

		/**<code>
			String out = " align='left' ";
			if (field.isTime() || field.getType().equals(BSDataType.BOOLEAN)
					|| field.isFK()) {
				out = " align='center' ";
			} else if (field.isNumber()) {
				out = " align='right' ";
			}
			</code>*/
		return out;
	}


	private String capitalize(String s) {
		return s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase();
	}
	/** <code>
	private void configHead(HttpSession session, HttpServletRequest request, JspWriter out ){
		BSHeadConfig head = (BSHeadConfig) session.getAttribute("BSHead");
		BSScript script = head.getScript();
		BSCss css = head.getCss();
		for (String oneScript : script.getListScriptNames()) {
			out.print("<script src='" + request.getContextPath()
					+ script.getPath() + oneScript + ".js'></script>");
		}

		for (String oneCss : css.getListCssNames()) {
			out.print("<LINK rel='stylesheet' type='text/css' src='"
					+ request.getContextPath() + css.getPath() + oneCss
					+ ".css'/>");
		}

	}</code>*/%>