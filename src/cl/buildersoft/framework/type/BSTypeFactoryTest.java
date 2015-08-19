package cl.buildersoft.framework.type;

import static org.junit.Assert.assertTrue;

import org.junit.Test;

import cl.buildersoft.framework.beans.BSField;

public class BSTypeFactoryTest{

	@Test
	public void testEvaluate1() {
		BSTypeFactory bsTypeFactory = new BSTypeFactory();
		BSField field = new BSField("", "");
		field.setType(BSFieldType.Timestamp);
			Boolean resp = bsTypeFactory.evaluate("2007-05-23d", field);
			assertTrue(resp);
			

	}

	@Test
	public void testEvaluate2() {
		BSTypeFactory bsTypeFactory = new BSTypeFactory();
		BSField field = new BSField("", "");
		field.setType(BSFieldType.Date);
			Boolean resp = bsTypeFactory.evaluate("2007-05-23d", field);
			assertTrue(resp);
			

	}
}
