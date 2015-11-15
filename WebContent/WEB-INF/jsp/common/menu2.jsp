<%@page import="cl.buildersoft.framework.beans.Option"%>
<%@page import="cl.buildersoft.framework.beans.Submenu"%>
<%@page import="cl.buildersoft.framework.beans.Menu"%>
<%@page import="java.util.Enumeration"%>
<%@page import="cl.buildersoft.framework.beans.Domain"%>
<%@page import="cl.buildersoft.framework.util.BSWeb"%>
<%@page import="java.util.List"%>

<!-- 
http://getbootstrap.com/components/#navbar

http://vadikom.github.io/smartmenus/src/demo/bootstrap-navbar.html
 -->

<div class="navbar navbar-default" role="navigation">
	<div class="navbar-header">
		<button type="button" class="navbar-toggle" data-toggle="collapse"
			data-target=".navbar-collapse">
			<span class="sr-only">Toggle navigation</span> <span class="icon-bar"></span>
			<span class="icon-bar"></span> <span class="icon-bar"></span>
		</button>
		<a class="navbar-brand" href="#">Dalea T&amp;A</a>
	</div>
	<div class="navbar-collapse collapse">

		<ul class="nav navbar-nav">
			<li><a
				href="${pageContext.request.contextPath}/servlet/Home?<%=BSWeb.randomString()%>">Inicio</a></li>

			<%=write_menu_in_menu_jsp(session, request)%>
		</ul>
		<ul class="nav navbar-nav navbar-right">
			<li><a href="#">${sessionScope.User.name} -
					${sessionScope.User.mail}</a>
				<ul class="dropdown-menu">
					<%
					List<Domain> domains = (List<Domain> ) session.getAttribute("Domains");
					if(domains.size()>1){ %>
					<li><a href="#">Dominio: ${sessionScope.Domain.name} (<%=domains.size()-1 %>)</a>
					
						<ul class="dropdown-menu">
						<%
						Long currentDomainId = ((Domain)session.getAttribute("Domain")).getId();
						for(Domain domain : domains){
							if(!domain.getId().equals(currentDomainId)){
						%>
							<li><a href="${pageContext.request.contextPath}/servlet/system/user/ChangeDomain?cId=<%=domain.getId()%>&<%=BSWeb.randomString()%>"><%=domain.getName() %></a></li>
							<%} 
							}%>
							
						</ul>
						</li>
						<%} else{%>
						

					<li><a href="${pageContext.request.contextPath}/servlet/Home?<%=BSWeb.randomString()%>">${sessionScope.Domain.name}</a></li>
<%} %>
					<li class="divider"></li>
					<li><a
						href="${pageContext.request.contextPath}/jsp/login/logout.jsp?<%=BSWeb.randomString()%>">Salir</a></li>
				</ul></li>
		</ul>
	</div>
	<!--/.nav-collapse -->
</div>

    

<%
String s = "";
Enumeration<String> names = session.getAttributeNames();%>
 <% 	while (names.hasMoreElements()) {
		String name = (String) names.nextElement();
		s=name + ": "+ session.getAttribute(name);	
}
%>
<!-- 
< % = s % >
 -->

<div class="container">
<%!private String write_menu_in_menu_jsp(HttpSession session, HttpServletRequest request) {
		Menu menuUser = (Menu) session.getAttribute("Menu");
		String out = "";
		//Boolean haveMore = null;
		if (menuUser != null) {
			String ctxPath = request.getContextPath();
			List<Submenu> main = menuUser.list();
			Option opt = null;
			String url = null;
			String label = null;
			for (Submenu submenu : main) {
				opt = submenu.getOption();
				out += "<li" + (submenu.list().size() > 0 ? " " : "") + ">";
				out += option2String(opt, ctxPath, true);
				out += writeSubMenu(submenu, ctxPath);
				out += "</li>\n";
			}
		}
		return out;
	}

	private String option2String(Option opt, String contextPath, Boolean isRoot) {
		String out = "";
		String url = opt.getUrl();
		String label = opt.getLabel();
		//String urlPath = "";
		String endTag = "</a>";
		//String startTag = "";
		String firstCharacter = "?";

		

		url = url == null ? "" : url;

		if (url.length() > 0) {
			out = "<a ";
			if (url.startsWith("/")) {
				url = contextPath + url;
			}
			//out += startTag;

			if (url.indexOf("?") > -1) {
				firstCharacter = "&";
			}
			out += "href='" + url + firstCharacter + BSWeb.randomString() + "'";
			//out += "href='" + url + "?" + BSWeb.randomString() + "'";
			endTag = "</a>";

		} else {
			out = "<a href='#' ";
		}

		if (isRoot) {
			//	out += " class=\'dropdown-toggle\' data-toggle=\'dropdown\' role='button' aria-expanded='false' ";
		}
		out += ">";

		out += label /*+ (isRoot ? "<b class='caret'></b>" : "")*/+ endTag;
		return out;
	}

	private String writeSubMenu(Submenu menu, String contextPath) {
		Option opt = null;
		String url = null;
		String label = null;
		List<Submenu> menuList = menu.list();
		Integer count = menuList.size();

		String out = count > 0 ? "\n<ul class='dropdown-menu'>" : "";

		for (Submenu submenu : menuList) {
			out += "<li>";
			out += option2String(submenu.getOption(), contextPath, false);
			out += writeSubMenu(submenu, contextPath);
			out += "</li>\n";
		}
		out += count > 0 ? "</ul>\n" : "\n";
		return out;
	}%>

