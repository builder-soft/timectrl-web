package cl.buildersoft.web.servlet.timectrl.turns;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.web.servlet.BSHttpServlet_;
import cl.buildersoft.timectrl.business.beans.Turn;
import cl.buildersoft.timectrl.business.beans.TurnDay;

@WebServlet("/servlet/timectrl/turns/TurnsDayByTurn")
public class TurnsDayByTurn extends BSHttpServlet_ {
	private static final long serialVersionUID = -8708209647234498026L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long id = Long.parseLong (readParameterOrAttribute(request, "cId"));
//		Long id = Long.parseLong(getId(request));
		

		BSBeanUtils bu = new BSBeanUtils();

		Connection conn = getConnection(request);

		TurnDay turnDay = new TurnDay();
		Turn turn = new Turn();
		@SuppressWarnings("unchecked")
		List<TurnDay> turnDays = (List<TurnDay>) bu.list(conn, turnDay, "cTurn=?", id);
		turn.setId(id);
		bu.search(conn, turn);

		closeConnection(conn);

		request.setAttribute("TurnDays", turnDays);
		request.setAttribute("Turn", turn);

		forward(request, response, "/WEB-INF/jsp/timectrl/employee/turns-detail.jsp");
	}

	private String getId(HttpServletRequest request) {
		String out = null;

		Object idObject = request.getAttribute("cId");
		if (idObject != null) {
			out = (String) idObject;
		} else {
			out = request.getParameter("cId");
		}
		return out;
	}
}
