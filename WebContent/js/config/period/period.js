function submitPeriod() {
	var elements = [ {
		name : 'cUF',
		desc : 'UF',
		type : 'Double',
		value : 0
	}, {
		name : 'cOvertimeFactor',
		desc : 'Factor de horas extras',
		type : 'Double',
		value : 0
	}, {
		name : 'cMinSalary',
		desc : 'Sueldo mínimo',
		type : 'Double',
		value : 0
	}, {
		name : 'cLimitGratification',
		desc : 'Tope de gratificación',
		type : 'Double',
		value : 0
	}, {
		name : 'cGratificationFactor',
		desc : 'Factor de gratificación',
		type : 'Double',
		value : 0
	}, {
		name : 'cLimitIPS',
		desc : 'Tope IPS',
		type : 'Double',
		value : 0
	}, {
		name : 'cLimitInsurance',
		desc : 'Tope Seguro cesantía',
		type : 'Double',
		value : 0
	}, {
		name : 'cLimitHealth',
		desc : 'Tope Sistema de Salud',
		type : 'Double',
		value : 0
	}, {
		name : 'cUTM',
		desc : 'UTM',
		type : 'Double',
		value : 0
	}, {
		name : 'cDaysForYear',
		desc : 'Días de vacaciones por año',
		type : 'Integer',
		value : 0
	} ];

	severalValidationsAndSubmit(elements, 'form');
}

