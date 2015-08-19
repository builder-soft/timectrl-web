package cl.buildersoft.timectrl.test;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class ComputeTest {

	public static void main(String[] args) {
		BigDecimal a = new BigDecimal(49);
		BigDecimal b = new BigDecimal(6);

		System.out.println(a.remainder(b));
		System.out.println(a.divide(b, 2, RoundingMode.CEILING));

	}

}
