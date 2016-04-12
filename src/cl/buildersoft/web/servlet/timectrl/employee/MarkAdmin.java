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

@WebServlet("/servlet/timectrl/employee/MarkAdmin")
@SuppressWarnings("unchecked")
public class MarkAdmin extends BSHttpServlet_ {
	private Integer range = 7;
	private static final long serialVersionUID = -6230848143914428453L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long id = Long.parseLong(readParameterOrAttribute(request, "cId"));

		BSConnectionFactory cf = new BSConnectionFactory();
		Connection conn = cf.getConnection(request);
		EmployeeService service = new EmployeeServiceImpl();
		Employee employee = service.getEmployee(conn, id);

		updateRange(conn);

		String dateFormat = BSDateTimeUtil.getFormatDate(conn);
		String dateTimeFormat = BSDateTimeUtil.getFormatDatetime(conn);

		Calendar endDate = getToday(request, dateFormat);
		Calendar startDate = getStartDate(endDate);
		Calendar startRange = getStartRange(endDate);
		Calendar oneDayBefore = getOneDayBefore(endDate);
		Calendar oneDayAfter = getOneDayAfter(endDate);
		Calendar endRange = getEndRange(endDate);

		List<Object[]> matrix = listMark(conn, employee, startDate, endDate);

		request.setAttribute("StartDate", BSDateTimeUtil.calendar2String(startDate, dateFormat));
		request.setAttribute("EndDate", BSDateTimeUtil.calendar2String(endDate, dateFormat));

		request.setAttribute("StartRange", BSDateTimeUtil.calendar2String(startRange, dateFormat));
		request.setAttribute("OneDayBefore", BSDateTimeUtil.calendar2String(oneDayBefore, dateFormat));
		request.setAttribute("OneDayAfter", BSDateTimeUtil.calendar2String(oneDayAfter, dateFormat));
		request.setAttribute("EndRange", BSDateTimeUtil.calendar2String(endRange, dateFormat));
		request.setAttribute("Today", BSDateTimeUtil.calendar2String(Calendar.getInstance(), dateFormat));

		request.setAttribute("DateFormat", dateFormat);
		request.setAttribute("DateTimeFormat", dateTimeFormat);
		request.setAttribute("Employee", employee);
		request.setAttribute("Area", service.readAreaOfEmployee(conn, employee));
		request.setAttribute("Post", service.readPostOfEmployee(conn, employee));
		request.setAttribute("Matrix", matrix);
		request.setAttribute("Machines", getMachines(conn));
		request.setAttribute("MarkTypes", getMarkType(conn));
		request.setAttribute("cId", id);
		request.setAttribute("Range", this.range);

		cf.closeConnection(conn);
		
		forward(request, response, "/WEB-INF/jsp/timectrl/employee/mark-admin2.jsp");
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
