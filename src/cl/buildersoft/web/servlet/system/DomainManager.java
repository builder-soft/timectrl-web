package cl.buildersoft.web.servlet.system;

import java.sql.Connection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import cl.buildersoft.framework.Semaphore;
import cl.buildersoft.framework.util.crud.BSTableConfig;
import cl.buildersoft.framework.web.servlet.HttpServletCRUD;

@WebServlet("/servlet/system/DomainManager")
public class DomainManager extends HttpServletCRUD {
	private static final long serialVersionUID = -2730980972177816284L;

	@Override
	protected BSTableConfig getBSTableConfig(HttpServletRequest request) {
		BSTableConfig table = initTable(request, "bsframework", "tDomain", this);
		// BSTableConfig table = new BSTableConfig("bsframework", "tDomain" );
		table.setTitle("Dominios");

		table.getField("cId").setLabel("Id");
		table.getField("cName").setLabel("Nombre");
		table.getField("cDatabase").setLabel("Base de datos");

		// BSTableConfig table = initTable(request, "bsframework.tDomain");

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
