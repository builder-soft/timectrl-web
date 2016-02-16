package cl.buildersoft.web.servlet.timectrl.turns;

import java.sql.Connection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import cl.buildersoft.framework.type.Semaphore;
import cl.buildersoft.framework.util.crud.BSAction;
import cl.buildersoft.framework.util.crud.BSActionType;
import cl.buildersoft.framework.util.crud.BSTableConfig;
import cl.buildersoft.web.servlet.common.HttpServletCRUD;

//import cl.buildersoft.web.servlet.BSHttpServlet;

@WebServlet("/servlet/timectrl/turns/TurnManager")
public class TurnManager extends HttpServletCRUD {
	private static final long serialVersionUID = -6279916596879232684L;

	@Override
	protected BSTableConfig getBSTableConfig(HttpServletRequest request) {
		BSTableConfig table = initTable(request, "tTurn");

		table.setTitle("Configuración de turnos");

		BSAction turnsAction = new BSAction("TURNS_DAY", BSActionType.Record);
		turnsAction.setLabel("Horarios de turnos");
		turnsAction.setUrl("/servlet/timectrl/turns/TurnsDayByTurn");

		table.addAction(turnsAction);

		return table;
	}

	@Override
	public Semaphore setSemaphore(Connection conn, Object[] values) {
		return null;
	}

	@Override
	public String getBusinessClass() {
		return this.getClass().getName();
	}

	@Override
	public void writeEventLog(Connection conn, String action, HttpServletRequest request, BSTableConfig table) {
		// TODO Auto-generated method stub

	}
}
