package cl.buildersoft.web.servlet.timectrl.turns;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.timectrl.business.beans.TurnDay;

/**
 * Servlet implementation class CopyTurn
 */
@WebServlet("/servlet/timectrl/turns/CopyTurn")
public class CopyTurn extends BSHttpServlet {
	private static final long serialVersionUID = -588251031998891982L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long sourceTurnDayId = Long.parseLong(request.getParameter("TurnDay"));
		Long parent = Long.parseLong(request.getParameter("Parent"));

		BSBeanUtils bu = new BSBeanUtils();
		BSmySQL mysql = new BSmySQL();
		Connection conn = getConnection(request);

		TurnDay sourceTurnDay = new TurnDay();
		sourceTurnDay.setId(sourceTurnDayId);
		bu.search(conn, sourceTurnDay);

		TurnDay targetTurnDay = new TurnDay();
		targetTurnDay.setBusinessDay(sourceTurnDay.getBusinessDay());
		targetTurnDay.setDay(getMaxDay(conn, mysql, parent) + 1);
		
		targetTurnDay.setEdgePrevIn(sourceTurnDay.getEdgePrevIn());
		targetTurnDay.setStartTime(sourceTurnDay.getStartTime());
		targetTurnDay.setEdgePostIn(sourceTurnDay.getEdgePostIn());
		
		targetTurnDay.setEdgePrevOut(sourceTurnDay.getEdgePrevOut());
		targetTurnDay.setEndTime(sourceTurnDay.getEndTime());
		targetTurnDay.setEdgePostOut(sourceTurnDay.getEdgePostOut());		
		
		targetTurnDay.setTurn(parent);
		bu.insert(conn, targetTurnDay);
		
		mysql.closeConnection(conn);

		request.setAttribute("cId", "" + parent);
		forward(request, response, "/servlet/timectrl/turns/TurnsDayByTurn");
	}

	private Integer getMaxDay(Connection conn, BSmySQL mysql, Long parent) {
		String sql = "select Max(cDay) from tTurnDay WHERE cTurn=?;";

		String last = mysql.queryField(conn, sql, parent);

		return Integer.parseInt(last);
	}

}
