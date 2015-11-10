package cl.buildersoft.timectrl.test;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ComputeTest {
	private static final Logger LOG = Logger.getLogger(ComputeTest.class.getName());

	public static void main(String[] args) {
		BigDecimal a = new BigDecimal(49);
		BigDecimal b = new BigDecimal(6);

		LOG.log(Level.FINE, a.remainder(b).toString());
		LOG.log(Level.FINE, a.divide(b, 2, RoundingMode.CEILING).toString());

	}

}
