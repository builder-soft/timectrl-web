package cl.buildersoft.web.servlet.timectrl.turns;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.util.BSConnectionFactory;
import cl.buildersoft.framework.web.servlet.BSHttpServlet_;
import cl.buildersoft.timectrl.business.beans.TurnDay;

@WebServlet("/servlet/timectrl/turns/DeleteTurn")
public class DeleteTurn extends BSHttpServlet_ {
	private static final long serialVersionUID = 1427361088388282595L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long turnDayId = Long.parseLong(request.getParameter("TurnDay"));
		Long parent = Long.parseLong(request.getParameter("Parent"));

		TurnDay turnDay = new TurnDay();

		turnDay.setId(turnDayId);

		BSBeanUtils bu = new BSBeanUtils();
		BSConnectionFactory cf = new BSConnectionFactory();
		Connection conn = cf.getConnection(request);
		bu.delete(conn, turnDay);
		cf.closeConnection(conn);

		request.setAttribute("cId", "" + parent);
		forward(request, response, "/servlet/timectrl/turns/TurnsDayByTurn", false);
	}

}
