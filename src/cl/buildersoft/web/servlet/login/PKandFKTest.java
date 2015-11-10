package cl.buildersoft.web.servlet.login;

import static org.junit.Assert.assertNull;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

import cl.buildersoft.framework.beans.User;
import cl.buildersoft.framework.services.impl.BSUserServiceImpl;
import cl.buildersoft.framework.util.BSConsole;
import cl.buildersoft.framework.util.BSDataUtils;
//import cl.buildersoft.framework.util;

import com.mysql.jdbc.DatabaseMetaData;

public class PKandFKTest {

	private static String TABLE = "tAFP";
	private static String DATABASE = "remu";

	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
	}

	@Test
	public void testDB() {
		try {
			BSDataUtils dau = new BSDataUtils();
			Connection conn = null;
			conn = dau.getConnection("org.gjt.mm.mysql.Driver", "localhost", DATABASE, "admin", "root");
			DatabaseMetaData dbmd = (DatabaseMetaData) conn.getMetaData();
			ResultSet rs = dbmd.getTables(DATABASE, null, null, null);

			BSConsole.println("TABLES:");
			BSConsole.println("--------------------");
			while (rs.next()) {
				ResultSetMetaData md = rs.getMetaData();
				for (int i = 1; i < md.getColumnCount(); i++) {
					BSConsole.println(md.getColumnName(i) + "=" + rs.getString(md.getColumnName(i)));
				}
				BSConsole.println("--------------------");
			}
			rs.close();

			rs = dbmd.getImportedKeys(null, null, TABLE);

			BSConsole.println("getImportedKeys:");
			BSConsole.println("--------------------");
			while (rs.next()) {
				ResultSetMetaData md = rs.getMetaData();
				for (int i = 1; i < md.getColumnCount(); i++) {
					BSConsole.println(md.getColumnName(i) + "=" + rs.getString(md.getColumnName(i)));
				}
				BSConsole.println("--------------------");
			}
			rs.close();

			BSConsole.println("getExportedKeys():");
			BSConsole.println("--------------------");
			rs = dbmd.getExportedKeys(null, null, TABLE);
			while (rs.next()) {
				ResultSetMetaData md = rs.getMetaData();
				for (int i = 1; i < md.getColumnCount(); i++) {
					BSConsole.println(md.getColumnName(i) + "=" + rs.getString(md.getColumnName(i)));
				}
				BSConsole.println("----------");
			}
			rs.close();

			BSConsole.println("getIndexInfo():");
			BSConsole.println("--------------------");
			rs = dbmd.getIndexInfo(DATABASE, null, TABLE, true, false);
			while (rs.next()) {
				ResultSetMetaData md = rs.getMetaData();
				for (int i = 1; i < md.getColumnCount(); i++) {
					BSConsole.println(md.getColumnName(i) + "=" + rs.getString(md.getColumnName(i)));
				}
				BSConsole.println("----------");
			}
			rs.close();

			BSConsole.println("getPrimaryKeys():");
			BSConsole.println("--------------------");
			rs = dbmd.getPrimaryKeys(DATABASE, null, TABLE);
			while (rs.next()) {
				ResultSetMetaData md = rs.getMetaData();
				for (int i = 1; i < md.getColumnCount(); i++) {
					BSConsole.println(md.getColumnName(i) + "=" + rs.getString(md.getColumnName(i)));
				}
				BSConsole.println("----------");
			}
			rs.close();

			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

	@Test
	public void testLogin2() {
		String mail = "noUser";
		String password = "admin";

		BSUserServiceImpl userService = new BSUserServiceImpl();

		User user = null;
		BSDataUtils dau = new BSDataUtils();
		Connection conn = null;
		conn = dau.getConnection("org.gjt.mm.mysql.Driver", "localhost", "bsframework", "admin", "root");

		user = userService.login(conn, mail, password);

		assertNull(user);

	}

	@Test
	public void testLogin3() {
		String mail = "demo";
		String password = "demo";

		BSUserServiceImpl userService = new BSUserServiceImpl();

		User user = null;
		BSDataUtils dau = new BSDataUtils();
		Connection conn = null;
		conn = dau.getConnection("org.gjt.mm.mysql.Driver", "localhost", "bsframework", "admin", "root");

		user = userService.login(conn, mail, password);

		assertNull(user);

	}

}
