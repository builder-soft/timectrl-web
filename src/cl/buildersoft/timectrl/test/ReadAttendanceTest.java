package cl.buildersoft.timectrl.test;

import cl.buildersoft.timectrl.api.ClassFactory;
import cl.buildersoft.timectrl.api._zkemProxy;

import com4j.Holder;

public class ReadAttendanceTest {

	public static void main(String[] args) {
		_zkemProxy api = ClassFactory.createzkemProxy();
		int machime = 1;

		Integer port = 4370;

		if (api.connect_Net("192.168.0.99", port.shortValue())) {
			int dwMachineNumber = 1;
			Holder<String> dwEnrollNumber = new Holder<String>("");
			Holder<Integer> dwVerifyMode = new Holder<Integer>(0);
			Holder<Integer> dwInOutMode = new Holder<Integer>(0);
			Holder<Integer> dwYear = new Holder<Integer>(0);
			Holder<Integer> dwMonth = new Holder<Integer>(0);
			Holder<Integer> dwDay = new Holder<Integer>(0);
			Holder<Integer> dwHour = new Holder<Integer>(0);
			Holder<Integer> dwMinute = new Holder<Integer>(0);
			Holder<Integer> dwSecond = new Holder<Integer>(0);
			Holder<Integer> dwWorkCode = new Holder<Integer>(0);

			api.enableDevice(machime, false);

			if (api.readGeneralLogData(machime)) {
				while (api.ssR_GetGeneralLogData(dwMachineNumber, dwEnrollNumber, dwVerifyMode, dwInOutMode, dwYear, dwMonth,
						dwDay, dwHour, dwMinute, dwSecond, dwWorkCode)) {

					System.out.println(dwYear.value + "-" + dwMonth.value + "-" + dwDay.value);
				}
			} else {
				Holder<Integer> error = new Holder<Integer>(0);
				api.getLastError(error);
				System.out.println(error);
			}
			api.enableDevice(machime, true);
			api.disconnect();
		}
	}
}
