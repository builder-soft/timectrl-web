package cl.buildersoft.framework.type;

import cl.buildersoft.framework.beans.BSField;
import cl.buildersoft.framework.exception.BSProgrammerException;

public class BSTypeFactory {
	private static final String BS = ".BS";

	public static BSFieldDataType create(BSField field) {
		return create(field.getType());
	}

	public static BSFieldDataType create(BSFieldType type) {
		// BSFieldType type = field.getType();
		String classInstance = BSTypeFactory.class.getPackage().getName() + BS + type.toString();
		BSFieldDataType out = null;
		try {
			Class newClass = Class.forName(classInstance);
			out = (BSFieldDataType) newClass.newInstance();
		} catch (Exception e) {
			throw new BSProgrammerException("", e.getMessage());
		}
		return out;
	}

	@SuppressWarnings("rawtypes")
	@Deprecated
	public boolean evaluate(String evaluateData, BSField field) {
		Boolean response = null;
		try {
			String classInstance = this.getClass().getPackage().getName() + BS + field.getType().toString();

			Class newClass = Class.forName(classInstance);

			BSFieldDataType data = (BSFieldDataType) newClass.newInstance();
			Class partypes[] = new Class[1];
			partypes[0] = String.class;
			Object[] obj = { evaluateData };
			response = (Boolean) data.getClass().getMethod("validData", partypes).invoke(data, obj);

		} catch (Exception e) {
			throw new BSProgrammerException("0000", "Error al procesar el tipo " + field.getType().toString());
		}
		return response;
	}
}
