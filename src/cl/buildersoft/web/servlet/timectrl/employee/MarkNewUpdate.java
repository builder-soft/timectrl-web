package cl.buildersoft.web.servlet.timectrl.employee;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.database.BSBeanUtils;
import cl.buildersoft.framework.database.BSmySQL;
import cl.buildersoft.framework.util.BSConfig;
import cl.buildersoft.framework.util.BSConnectionFactory;
import cl.buildersoft.framework.util.BSDateTimeUtil;
import cl.buildersoft.framework.web.servlet.BSHttpServlet_;
import cl.buildersoft.timectrl.business.beans.Employee;
import cl.buildersoft.timectrl.business.beans.Machine;
import cl.buildersoft.timectrl.business.beans.MarkType;
import cl.buildersoft.timectrl.business.services.EmployeeService;
import cl.buildersoft.timectrl.business.services.impl.EmployeeServiceImpl;

@WebServlet("/servlet/timectrl/employee/MarkNewUpdate")
@SuppressWarnings("unchecked")
public class MarkNewUpdate extends BSHttpServlet_ {
	private static final long serialVersionUID = -8204980202948693393L;
	private Integer range = 7;
	
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long id = Long.parseLong(readParameterOrAttribute(request, "cId"));
		String today = readParameterOrAttribute(request, "Today");
		
		BSConnectionFactory cf = new BSConnectionFactory();
		Connection conn = cf.getConnection(request);
		EmployeeService service = new EmployeeServiceImpl();
		Employee employee = service.getEmployee(conn, id);
		
		
		updateRange(conn);

		String dateFormat = BSDateTimeUtil.getFormatDate(conn);

		Calendar endDate = getToday(request, dateFormat);
		Calendar startDate = getStartDate(endDate);

		List<Object[]> matrix = listMark(conn, employee, startDate, endDate);
		
		
		request.setAttribute("Matrix", matrix);
		request.setAttribute("Machines", getMachines(conn));
		request.setAttribute("MarkTypes", getMarkType(conn));
		request.setAttribute("cId", id);
		request.setAttribute("Employee", employee);
		request.setAttribute("today", today);
		
		cf.closeConnection(conn);
		
		forward(request, response, "/WEB-INF/jsp/timectrl/employee/mark-new-update.jsp");
	}

	private void updateRange(Connection conn) {
		BSConfig config = new BSConfig();
		Integer rangeLocal = config.getInteger(conn, "RANGE_MARK");
		if (rangeLocal != null) {
			this.range = rangeLocal;
		}
	}

	private List<MarkType> getMarkType(Connection conn) {
		List<MarkType> markTypes = null;
		BSBeanUtils bu = new BSBeanUtils();
		markTypes = (List<MarkType>) bu.listAll(conn, new MarkType());
		return markTypes;
	}

	private List<Machine> getMachines(Connection conn) {
		List<Machine> machines = null;
		BSBeanUtils bu = new BSBeanUtils();
		machines = (List<Machine>) bu.listAll(conn, new Machine());
		return machines;
	}

	private Calendar getToday(HttpServletRequest request, String dateFormat) {
		String today = request.getParameter("Today");
		Calendar out = null;
		if (today == null) {
			out = Calendar.getInstance();
		} else {
			out = BSDateTimeUtil.string2Calendar(today, dateFormat);
		}
		return out;
	}

	private Calendar getEndRange(Calendar endDate) {
		return cloneCalendarAdding(endDate, range);
	}

	private Calendar getOneDayAfter(Calendar endDate) {
		return cloneCalendarAdding(endDate, 1);
	}

	private Calendar getOneDayBefore(Calendar endDate) {
		return cloneCalendarAdding(endDate, -1);
	}

	private Calendar getStartRange(Calendar startDate) {
		return cloneCalendarAdding(startDate, (range * -1));
	}

	private Calendar getStartDate(Calendar endDate) {
		return cloneCalendarAdding(endDate, range * -1);
	}

	private Calendar cloneCalendarAdding(Calendar date, Integer days) {
		Calendar out = Calendar.getInstance();
		out.setTimeInMillis(date.getTimeInMillis());
		out.add(Calendar.DATE, days);
		return out;
	}

	private List<Object[]> listMark(Connection conn, Employee employee, Calendar startDate, Calendar endDate) {
		List<Object> parms = new ArrayList<Object>();
		parms.add(employee.getId());
		parms.add(BSDateTimeUtil.calendar2Timestamp(startDate));
		parms.add(BSDateTimeUtil.calendar2Timestamp(endDate));

		BSmySQL mysql = new BSmySQL();
		ResultSet rs = mysql.callSingleSP(conn, "pListMarkOfEmployee", parms);
		List<Object[]> matrix = mysql.resultSet2Matrix(rs);
		mysql.closeSQL(rs);
		mysql.closeSQL();
		
		return matrix;
	}	
	

}
