package cl.buildersoft.web.servlet.timectrl.turns;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.business.beans.TurnDay;

/**
 * Servlet implementation class GetTurnDayAjax
 */
@WebServlet("/servlet/timectrl/turns/GetTurnDayAjax")
public class GetTurnDayAjax extends BSHttpServlet {

	private static final long serialVersionUID = "/servlet/timectrl/turns/GetTurnDayAjax".hashCode();

	public GetTurnDayAjax() {
		super();
	}

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long id = Long.parseLong(readParameterOrAttribute(request, "Id"));

		Connection conn = getConnection(request);
		TurnDay turnDay = new TurnDay();
		turnDay.setId(id);

		BSBeanUtils bu = new BSBeanUtils();
		bu.search(conn, turnDay);
		
		closeConnection(conn);
		request.setAttribute("TurnDay", turnDay);
		request.setAttribute("CurrentRow", request.getParameter("currentRow"));
		
		forward(request, response, "/WEB-INF/jsp/timectrl/turn/get-turn-day-ajax.jsp");
	}

}
