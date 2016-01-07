<%
request.getSession(false).invalidate();
response.sendRedirect(getServletContext().getContextPath());
%>