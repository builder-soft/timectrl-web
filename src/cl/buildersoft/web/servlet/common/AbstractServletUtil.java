package cl.buildersoft.web.servlet.common;

import java.io.IOException;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cl.buildersoft.framework.exception.BSProgrammerException;
import cl.buildersoft.framework.util.BSHttpServlet;
import cl.buildersoft.framework.util.BSUtils;
import cl.buildersoft.framework.util.ReflectionUtils;
import cl.buildersoft.framework.util.crud.BSField;

@Deprecated
public class AbstractServletUtil extends BSHttpServlet {
	private static final Logger LOG = Logger.getLogger(AbstractServletUtil.class.getName());
	private static final long serialVersionUID = -34792656017725168L;

	@Deprecated
	protected String getFieldsNamesWithCommas(BSField[] fields) {
		String out = "";
		if (fields.length == 0) {
			out = "*";
		} else {
			for (BSField field : fields) {
				out += field.getName() + ",";
			}
			out = out.substring(0, out.length() - 1);
		}
		return out;
	}

	protected String getCommas(BSField[] fields) {
		String out = "";

		for (BSField field : fields) {
			// for (int i = 0; i < fields.length; i++) {
			if (!field.isReadonly()) {
				out += "?,";
			}
		}
		out = out.substring(0, out.length() - 1);
		return out;
	}

	protected String unSplit(BSField[] tableFields, String s) {
		/**<code>
		String out = "";
		for (BSField f : tableFields) {
			if (!f.isReadonly()) {
				out += f.getName() + s;
			}
		}
		out = out.substring(0, out.length() - 1);
		return out;
		</code>*/
		return BSUtils.unSplitField(tableFields, s);
	}

	protected List<Object> array2List(Object... prms) {
		List<Object> out = new ArrayList<Object>();

		for (Object o : prms) {
			out.add(o);
		}

		return out;
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		LOG.log(Level.INFO, "Method doGet of class AbstractServletUtil is deprecated, will be delete.");

		this.doPost(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		LOG.log(Level.INFO, "Method doPost of class AbstractServletUtil is deprecated, will be delete.");
		Object[] parameters = { request, response };
		String servletName = "cl.buildersoft.web." + request.getRequestURI().substring(12).replaceAll("/", ".");
		String methodName = request.getParameter("Method");
		Object servletClazz;

		try {
			servletClazz = Class.forName(servletName).newInstance();
			ReflectionUtils.execute(methodName, servletClazz, parameters);
		} catch (InstantiationException e) {
			e.printStackTrace();
			throw new BSProgrammerException(e);
		} catch (IllegalAccessException e) {
			e.printStackTrace();
			throw new BSProgrammerException(e);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			throw new BSProgrammerException(e);
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
			throw new BSProgrammerException(e);
		} catch (InvocationTargetException e) {
			e.printStackTrace();
			throw new BSProgrammerException(e);
		}

	}

	protected ServletOutputStream configHeaderAsFile(HttpServletResponse response, String fileName) throws IOException {
		ServletOutputStream output = response.getOutputStream();
		response.setContentType("text/csv");
		String disposition = "attachment; fileName=" + fileName;
		response.setHeader("Content-Disposition", disposition);
		return output;
	}

	protected ServletOutputStream configHeaderAsCSV(HttpServletResponse response, String fileName) throws IOException {
		return configHeaderAsFile(response, fileName + ".csv");
	}

}
