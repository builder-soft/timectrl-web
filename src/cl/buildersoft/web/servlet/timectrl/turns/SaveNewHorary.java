package cl.buildersoft.web.servlet.timectrl.turns;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.web.servlet.BSHttpServlet_;
import cl.buildersoft.timectrl.business.beans.TurnDay;

@WebServlet("/servlet/timectrl/turns/SaveNewHorary")
public class SaveNewHorary extends BSHttpServlet_ {
	private static final long serialVersionUID = -7071535493708573254L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long parent = Long.parseLong(request.getParameter("Parent"));
		Integer day = Integer.parseInt(request.getParameter("Day"));

		Integer edgePrevIn = Integer.parseInt(request.getParameter("EdgePrevIn"));
		String startTime = request.getParameter("StartTime");
		Integer edgePostIn = Integer.parseInt(request.getParameter("EdgePostIn"));
		Integer edgePrevOut = Integer.parseInt(request.getParameter("EdgePrevOut"));
		String endTime = request.getParameter("EndTime");
		Integer edgePostOut = Integer.parseInt(request.getParameter("EdgePostOut"));

		Boolean businessDay = Boolean.parseBoolean(request.getParameter("BusinessDay"));

		TurnDay turnDay = new TurnDay();

		turnDay.setTurn(parent);
		turnDay.setDay(day);
		turnDay.setBusinessDay(businessDay);

		turnDay.setEdgePrevIn(edgePrevIn);
		turnDay.setStartTime(startTime);
		turnDay.setEdgePostIn(edgePostIn);

		turnDay.setEdgePrevOut(edgePrevOut);
		turnDay.setEndTime(endTime);
		turnDay.setEdgePostOut(edgePostOut);

		BSBeanUtils bu = new BSBeanUtils();
		BSmySQL mysql = new BSmySQL();
		Connection conn = getConnection(request);
		bu.save(conn, turnDay);
		mysql.closeConnection(conn);

		request.setAttribute("cId", "" + parent);

		forward(request, response, "/servlet/timectrl/turns/TurnsDayByTurn");
	}

}
