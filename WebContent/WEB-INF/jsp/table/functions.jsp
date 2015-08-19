<%@page import="cl.buildersoft.framework.type.BSFieldType"%>
<%@page import="cl.buildersoft.framework.beans.BSField"%>
<%@page import="java.util.List"%>
<%@page import="java.io.PrintWriter"%>
 
<%!private String getAlign(BSField field) {
		String out = " align='left' ";
		if (field.isTime() || field.getType().equals(BSFieldType.Boolean)
				|| field.isFK()) {
			out = " align='center' ";
		} else if (field.isNumber()) {
			out = " align='right' ";
		}
		return out;
	}

	
	private String capitalize(String s) {
		return s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase();
	}

	/**<code>
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