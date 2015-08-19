# use rsa_timecontrol;

/*
D:\workspace\timectrl-web\WebContent\WEB-INF\sql\timecontrol

Respaldar:
mysqldump -u root -padmin timecontrol > database-backup.sql.txt

Restaurar base de datos:
mysql -u root -padmin timecontrol < database-backup.sql.txt


Probar Reporte:
mysql -u root -padmin timecontrol -t < custom-report.sql.txt

*/
/* este es mi cambio*/
DROP PROCEDURE IF EXISTS pListTurnos2;
DROP FUNCTION IF EXISTS fSolveType2;
DROP FUNCTION IF EXISTS fSolveTypeAsNum2;
DROP FUNCTION IF EXISTS fLuchTime2;
DROP FUNCTION IF EXISTS fStartTime2;
DROP FUNCTION IF EXISTS fMarkInTime2;
DROP FUNCTION IF EXISTS fExtraTime2;
DROP FUNCTION IF EXISTS fExtraTimeAsMins2;
DROP FUNCTION IF EXISTS fEndTime2;
DROP FUNCTION IF EXISTS fMarkOutTime2;
DROP FUNCTION IF EXISTS fGetMarkTime2;
DROP FUNCTION IF EXISTS fGetLimitTime2;
DROP FUNCTION IF EXISTS fGetJournalString2;
DROP FUNCTION IF EXISTS fGetJournal2;
DROP FUNCTION IF EXISTS fInferTime2;
DROP FUNCTION IF EXISTS fTimeFormat2;
DROP FUNCTION IF EXISTS fResolveTime2;
DROP FUNCTION IF EXISTS fSolveTypeArea2;
DROP FUNCTION IF EXISTS fDayOfWeek2;
DROP FUNCTION IF EXISTS fSolveTypeTurno2;
DROP FUNCTION IF EXISTS fCheckOutFriday2;
DROP FUNCTION IF EXISTS fMarkAndUserToTurnDayId2;

DELIMITER $$
/** Este es un cambio de prueba*/

CREATE FUNCTION fCheckOutFriday2() RETURNS CHAR(5)
BEGIN
	RETURN '16:00';
END$$

CREATE FUNCTION fTimeFormat2(vTime TIME) RETURNS CHAR(8)
BEGIN
	RETURN vTime;
END$$

CREATE FUNCTION fStartTime2(vMarkTime DATETIME, vUserId BIGINT(20), vType CHAR(1)) RETURNS CHAR(80)
BEGIN
	RETURN fGetLimitTime2(vMarkTime, vUserId, vType, 1);
END$$

CREATE FUNCTION fEndTime2(vMarkTime DATETIME, vUserId INT, vType CHAR(1)) RETURNS CHAR(8)
BEGIN
	RETURN fGetLimitTime2(vMarkTime, vUserId, vType, 4);
END$$

CREATE FUNCTION fDayOfWeek2(vMarkTime DATETIME) RETURNS CHAR(10)
BEGIN 
	DECLARE vOut CHAR(10) DEFAULT '';
	
	CASE DAYOFWEEK(vMarkTime)
		WHEN 1 THEN SET vOut = 'Domingo';
		WHEN 2 THEN SET vOut = 'Lunes';
		WHEN 3 THEN SET vOut = 'Martes';
		WHEN 4 THEN SET vOut = 'Miercoles';
		WHEN 5 THEN SET vOut = 'Jueves';
		WHEN 6 THEN SET vOut = 'Viernes';
		WHEN 7 THEN SET vOut = 'Sabado';
		ELSE SET vOut = '';
	END CASE;
	
	RETURN vOut;
END$$


CREATE FUNCTION fMarkAndUserToTurnDayId2(vMarkTime DATETIME, vUserId BIGINT(20)) RETURNS BIGINT(20)
BEGIN 
	DECLARE vOut BIGINT(20);
	DECLARE vRTurno BIGINT(20);
	DECLARE vStart DATE;
	DECLARE vEnd DATE;
	DECLARE vDaysCount INTEGER;
	DECLARE vDaysOfTurn INTEGER;
	DECLARE vTurnDay BIGINT(20);
	DECLARE vTurno BIGINT(20);

#	SET vRTurno = fGetJournal2(vUserId, vMarkTime);
	SELECT tR_EmployeeTurn.cId INTO vRTurno 
	FROM tR_EmployeeTurn 
	WHERE cEmployee = vUserId AND vMarkTime BETWEEN cStartDate AND cEndDate;
	
	SELECT cTurn INTO vTurno 
	FROM tR_EmployeeTurn 
	WHERE cId = vRTurno;
	
	SELECT cStartDate, cEndDate INTO vStart, vEnd
	FROM tR_EmployeeTurn
	WHERE cId = vRTurno;
	
	SELECT MAX(cDay) INTO vDaysOfTurn 
	FROM tTurnDay
	WHERE cTurn = vTurno;
	
	SET vDaysCount = DATEDIFF(vMarkTime, vStart) % vDaysOfTurn;
	SET vDaysCount = vDaysCount + 1;
	
	SELECT cId INTO vOut 
	FROM tTurnDay 
	WHERE cTurn = vTurno AND cDay = vDaysCount;
	
	RETURN vOut;
END$$

CREATE FUNCTION fGetLimitTime2(vMarkTime DATETIME, vUserId BIGINT(20), vTypeAsNum INT, vExpectedType INT) RETURNS CHAR(8)
BEGIN
	DECLARE vOut CHAR(8) DEFAULT '';
	DECLARE vTurnDayId BIGINT(20);
	DECLARE vTurnDay BIGINT(20);
	DECLARE vDaysCount INTEGER;
	
	DECLARE vRTurno BIGINT(20);
	DECLARE vStart DATE;
	DECLARE vEnd DATE;
	DECLARE vDaysOfTurn INTEGER;

	SET vTurnDayId = fMarkAndUserToTurnDayId2(vMarkTime, vUserId);
	/*
	return vTurnDayId;
	
	#SET vRTurno	 = fGetJournal2(vUserId, vMarkTime);
	
	SELECT cTurn INTO vTurnDayId 
	FROM tR_EmployeeTurn 
	WHERE cId = vRTurno;
	
	SELECT cStartDate, cEndDate INTO vStart, vEnd
	FROM tR_EmployeeTurn
	WHERE cId = vRTurno;
	
	SELECT MAX(cDay) INTO vDaysOfTurn 
	FROM tTurnDay
	WHERE cTurn = vTurnDayId;
	
	SET vDaysCount = DATEDIFF(vMarkTime, vStart) % vDaysOfTurn;
	SET vDaysCount = vDaysCount + 1;
	
	SELECT cId INTO vTurnDay 
	FROM tTurnDay 
	WHERE cTurn = vTurno AND cDay = vDaysCount;
	*/
	#return vTurnDayId;
	
	IF(vTypeAsNum = 1 AND vExpectedType = 1) THEN
		IF(vTurnDay IS NULL) THEN
			SET vOut = fInferTime2(vMarkTime);
		ELSE
			SELECT cStartTime INTO vOut 
			FROM tTurnDay 
			WHERE cId = vTurnDayId;
		END IF;
	END IF;
/*
		CASE vTurno
			WHEN 'Administrativo' THEN SET vOut = STR_TO_DATE('08:00', '%H:%i');
			WHEN 'Admin Diego' THEN SET vOut = STR_TO_DATE('08:00', '%H:%i');
			WHEN 'Admin1' THEN SET vOut = STR_TO_DATE('08:00', '%H:%i');
			WHEN 'Admin2' THEN SET vOut = STR_TO_DATE('08:45', '%H:%i');
			WHEN 'Admin3' THEN SET vOut = STR_TO_DATE('09:30', '%H:%i');
			ELSE SET vOut = fInferTime(vMarkTime);
		END CASE;
*/
	
	IF(vTypeAsNum = 4 AND vExpectedType = 4) THEN
		IF(vTurnDay IS NULL) THEN
			SET vOut = fInferTime2(vMarkTime);
		ELSE
			SELECT cEndTime INTO vOut 
			FROM tTurnDay 
			WHERE cId = vTurnDayId;
		END IF;
	END IF;
/*
		IF(DAYOFWEEK(vMarkTime)=6) THEN
			SET vOut = STR_TO_DATE(fCheckOutFriday(), '%H:%i');
		ELSE
			CASE vTurno
				WHEN 'Administrativo'	THEN SET vOut = STR_TO_DATE('18:00', '%H:%i');
				WHEN 'Admin Diego'		THEN SET vOut = STR_TO_DATE('20:00', '%H:%i');
				WHEN 'Admin1'			THEN SET vOut = STR_TO_DATE('17:30', '%H:%i');
				WHEN 'Admin2'			THEN SET vOut = STR_TO_DATE('18:15', '%H:%i');
				WHEN 'Admin3'			THEN SET vOut = STR_TO_DATE('19:00', '%H:%i');
				ELSE SET vOut = fInferTime(vMarkTime);
			END CASE;
		END IF;
*/
	
#	SET vOut = CONCAT(vTypeAsNum, ' - ', vExpectedType, ' - ', vOut);
	
	RETURN vOut;
END$$

CREATE FUNCTION fGetJournalString2(vUserId BIGINT(20), vMarkTime DATETIME) RETURNS CHAR(50)
BEGIN
	DECLARE vOut CHAR(50) DEFAULT '';
	
	SELECT tTurn.cName INTO vOut 
	FROM tR_EmployeeTurn 
	LEFT JOIN tTurn ON tTurn.cId = tR_EmployeeTurn.cTurn
	WHERE cEmployee = vUserId AND vMarkTime BETWEEN cStartDate AND cEndDate;
/**	
	SELECT Street INTO vOut FROM userinfo WHERE UserId = vUserId LIMIT 1;
*/
	
	RETURN vOut;
END$$

CREATE FUNCTION fGetJournal2(vUserId BIGINT(20), vMarkTime DATETIME) RETURNS BIGINT(20)
BEGIN
	DECLARE vOut BIGINT(20);
	
	SELECT tR_EmployeeTurn.cId INTO vOut 
	FROM tR_EmployeeTurn 
	WHERE cEmployee = vUserId AND vMarkTime BETWEEN cStartDate AND cEndDate;

/**	
	SELECT Street INTO vOut FROM userinfo WHERE UserId = vUserId LIMIT 1;
*/
	
	RETURN vOut;
END$$

CREATE FUNCTION fInferTime2(vMarkTime DATETIME) RETURNS CHAR(8)
BEGIN
	/**
Administrativo 8:00 a 18:00
Turno MaÃ±ana 8:00 a 16:00
Turno Tarde 16:00 a 24:00
Turno Noche 24:00 a 08:00
	 * */
	DECLARE vTime1 TIME DEFAULT '00:00:00';
	DECLARE vTime2 TIME DEFAULT '08:00:00';
	DECLARE vTime3 TIME DEFAULT '16:00:00';
	DECLARE vTime4 TIME DEFAULT '20:00:00';
	DECLARE vOut CHAR(10) DEFAULT '';
	
	SET vOut = fResolveTime2(vTime1, vMarkTime);
	
	IF(LENGTH(vOut) = 0) THEN
		SET vOut = fResolveTime2(vTime2, vMarkTime);
		IF(LENGTH(vOut) = 0) THEN
			SET vOut = fResolveTime2(vTime3, vMarkTime);
			IF(LENGTH(vOut) = 0) THEN
				SET vOut = fResolveTime2(vTime4, vMarkTime);
			END IF;
		END IF;
	END IF;
/*
	IF(LENGTH(vOut)>0) THEN
		SET vOut = fTimeFormat(vOut);
	END IF;
*/	
	RETURN vOut;
	
END$$

CREATE FUNCTION fResolveTime2(vTime TIME, vMarkTime DATETIME) RETURNS CHAR(100)
BEGIN
/*
 Si la hora de limite es igual a 00:00 entonces, preguntar si la hora es 23:xx,
 la y comparar la marca con la hora y con fecha sumando un dia. Si la hora es 
 00:xx entonces comprar con el mismo dia.
*/
	DECLARE vOut CHAR(100) DEFAULT '';
	DECLARE vStartRange DATETIME;
	DECLARE	vEndRange DATETIME;
	DECLARE vTemp CHAR(100);
	
	SET vTemp = DATE_FORMAT(vMarkTime, concat('%Y-%m-%d ', vTime));
	IF(HOUR(vMarkTime)=23) THEN
		SET vTemp = TIMESTAMPADD(DAY, 1, vTemp);
	END IF;

	SET vStartRange = TIMESTAMPADD(HOUR, -1, vTemp);
	SET vEndRange = TIMESTAMPADD(HOUR, 1, vTemp);
	
	
/*	RETURN CONCAT( vTemp, ' between ', vStartRange, ' AND ', vEndRange, ' = ', vOut);*/
	

/*
	IF(TIME(vStartTime)<0) THEN
		SET vStartTime = TIMESTAMPADD(DAY,-1,vStartTime);
	END IF;
	
*/
	IF(vMarkTime > vStartRange AND vMarkTime < vEndRange) THEN
		SET vOut = vTime;
	END IF;
	
/*	RETURN CONCAT( vStartRange, ' - ', vEndRange, ' = ', vOut);*/
	
	RETURN vOut;
	
END$$ 


CREATE FUNCTION fSolveTypeTurno2(vUserId BIGINT(20), vMarkTime DATETIME) RETURNS char(50)
/** Esta funcion debe retornar el rango del horario de la marca. */
BEGIN
	DECLARE vOut CHAR(50) DEFAULT '';
	DECLARE vRTurno BIGINT(20);
	
	
	SET vRTurno = fGetJournal2(vUserId, vMarkTime);
	
	return vRTurno;
	
	SELECT CONCAT(cStartTime, ' - ', cEndTime) INTO vOut 
	FROM tTurnDay
	WHERE cTurn=vRTurno;
	
	
	RETURN vOut;
END$$

CREATE FUNCTION fSolveTypeArea2(pType CHAR(5)) RETURNS char(50) 
BEGIN
	DECLARE vOut CHAR(50) DEFAULT '';
	
	CASE pType
		WHEN '1 ' THEN SET vOut = 'Enlasa';
		WHEN '2 ' THEN SET vOut = 'Teno';
		WHEN '3 ' THEN SET vOut = 'Trapen';
		WHEN '4 ' THEN SET vOut = 'Peñon';
		WHEN '5 ' THEN SET vOut = 'Diego';
		/*
		WHEN '1 ' THEN SET vOut = 'RSA Seguros ';
		WHEN '2 ' THEN SET vOut = 'GERENCIA DE IT ';
		WHEN '3 ' THEN SET vOut = 'VICEPRESIDENCIA DE OPERACIONES ';
		WHEN '4 ' THEN SET vOut = 'VICEPRESIDENCIA DE FINANZAS ';
		WHEN '5 ' THEN SET vOut = 'VICEPRESIDENCIA COMERCIAL ';
		WHEN '6 ' THEN SET vOut = 'VICEPRESIDENCIA DE AFFINITY ';
		WHEN '7 ' THEN SET vOut = 'VICEPRESIDENCIA DE INDEMNIZACI ';
		WHEN '8 ' THEN SET vOut = 'VICEPRESIDENCIA TECNICA ';
		WHEN '9 ' THEN SET vOut = 'VICEPRESIDENCIA DE CLIENTES ';
		WHEN '10 ' THEN SET vOut = 'GERENCIA GENERAL ';
		WHEN '11 ' THEN SET vOut = 'VICEPRESIDENCIA DE PERSONAS ';
		WHEN '12 ' THEN SET vOut = 'COBRANZAS ';
		WHEN '13 ' THEN SET vOut = 'GERENCIA DE SMALL BROKERS ';
		WHEN '14 ' THEN SET vOut = 'VIÑA DEL MAR ';
		WHEN '15 ' THEN SET vOut = 'ANTOFAGASTA ';
		WHEN '16 ' THEN SET vOut = 'CURICO ';
		WHEN '17 ' THEN SET vOut = 'SANTIAGO ';
		WHEN '18 ' THEN SET vOut = 'GERENCIA NEGOCIOS COMERCIALES ';
		WHEN '19 ' THEN SET vOut = 'OPERACIONES MASIVOS ';
		WHEN '20 ' THEN SET vOut = 'MANTENCION DE NEGOCIO ';
		WHEN '21 ' THEN SET vOut = 'PUERTO MONTT ';
		WHEN '22 ' THEN SET vOut = 'OSORNO ';
		WHEN '23 ' THEN SET vOut = 'SUB-GERENCIA DE SINIESTROS RAMOS MASIVOS ';
		WHEN '24 ' THEN SET vOut = 'SUB-GERENCIA DE ADMINISTRACION ';
		WHEN '25 ' THEN SET vOut = 'SUB-GERENCIA CONTACT CENTER ';
		WHEN '26 ' THEN SET vOut = 'GERENCIA CONTROL FINANCIERO ';
		WHEN '27 ' THEN SET vOut = 'GERENCIA DE PLANIFICACIÓN Y CONTROL ';
		WHEN '28 ' THEN SET vOut = 'BBC COPIAPO ';
		WHEN '29 ' THEN SET vOut = 'AGUSTINAS ';
		WHEN '30 ' THEN SET vOut = 'CENTRO DE ATENCION IRARRAZAVAL ';
		WHEN '31 ' THEN SET vOut = 'IQUIQUE ';
		WHEN '32 ' THEN SET vOut = 'OPERACIONES TRADICIONAL ';
		WHEN '33 ' THEN SET vOut = 'RANCAGUA ';
		WHEN '34 ' THEN SET vOut = 'GERENCIA TECNICA DE MARINE/INGENIERIA ';
		WHEN '35 ' THEN SET vOut = 'SUBGERENCIA DE REASEGUROS ';
		WHEN '36 ' THEN SET vOut = 'GERENCIA TECNICA DE PROPERTY/RC ';
		WHEN '37 ' THEN SET vOut = 'VICEPRESIDENCIA CLIENTES ';
		WHEN '38 ' THEN SET vOut = 'GERENCIA DE ESTRATEGIA Y EXCELENCIA OPER ';
		WHEN '40 ' THEN SET vOut = 'VALDIVIA ';
		WHEN '41 ' THEN SET vOut = 'TALCA ';
		WHEN '42 ' THEN SET vOut = 'SERVICIO CORREDORES ';
		WHEN '43 ' THEN SET vOut = 'SUBGERENCIA DE PRODUCTOS Y GEONEGOCIOS ';
		WHEN '44 ' THEN SET vOut = 'SUBGERENCIA DE SINIESTROS RIESGOS MAYORE ';
		WHEN '45 ' THEN SET vOut = 'VICEPRESIDENCIA DE AFFIN ';
		WHEN '46 ' THEN SET vOut = 'PROYECTO S2015 ';
		WHEN '47 ' THEN SET vOut = 'FISCALIA ';
		WHEN '48 ' THEN SET vOut = 'ARICA ';
		WHEN '49 ' THEN SET vOut = 'VICEPRESIDENCIA DE FINAN ';
		WHEN '50 ' THEN SET vOut = 'DOCUMENTACION ';
		WHEN '51 ' THEN SET vOut = 'GERENCIA DE VEHICULOS PERSONALES ';
		WHEN '52 ' THEN SET vOut = 'OPERACIONES SOT ';
		WHEN '53 ' THEN SET vOut = 'SUBGERENCIA DE RMS ';
		WHEN '54 ' THEN SET vOut = 'VICEPRESIDENCIA DE PERSO ';
		WHEN '55 ' THEN SET vOut = 'GERENCIA DE MARKETING ';
		WHEN '56 ' THEN SET vOut = 'DESARROLLO DE NEGOCIO ';
		WHEN '57 ' THEN SET vOut = 'PROYECTO HUNTERS ';
		WHEN '58 ' THEN SET vOut = 'VICEPRESIDENCIA DE INDEMNIZACIONES ';
		WHEN '59 ' THEN SET vOut = 'LA SERENA ';
		WHEN '60 ' THEN SET vOut = 'GERENCIA NEGOCIOS CORPORATIVOS ';
		WHEN '61 ' THEN SET vOut = 'COBRANZA CANALES MASIVOS ';
		WHEN '62 ' THEN SET vOut = 'SUB-GERENCIA CALIDAD ';
		WHEN '63 ' THEN SET vOut = 'TEMUCO ';
		WHEN '64 ' THEN SET vOut = 'COASEGUROS Y REASEGUROS ';
		WHEN '65 ' THEN SET vOut = 'SUBGERENCIA DE CASCO Y PISCICULTURA ';
		WHEN '66 ' THEN SET vOut = 'GERENCIA SUCURSALES Y GERENCIAS ZONALES ';
		WHEN '67 ' THEN SET vOut = 'GERENCIA DE LINEAS PERSONALES ';
		WHEN '68 ' THEN SET vOut = 'CONCEPCION ';
		WHEN '69 ' THEN SET vOut = 'CHILLAN ';
		WHEN '70 ' THEN SET vOut = 'LOS ANGELES ';
		WHEN '71 ' THEN SET vOut = 'SUBGERENCIA DE CARGO ';
		WHEN '72 ' THEN SET vOut = 'SUB-GERENCIA DE CUENTAS CORRIENTES ';
		WHEN '73 ' THEN SET vOut = 'VIDA ';
		WHEN '74 ' THEN SET vOut = 'VEHICULOS COMERCIALES ';
		WHEN '75 ' THEN SET vOut = 'GERENCIA DE PROYECTOS FINANCIEROS ';
		WHEN '76 ' THEN SET vOut = 'TERREMOTO ';
		WHEN '77 ' THEN SET vOut = 'PUNTA ARENAS ';
		WHEN '78 ' THEN SET vOut = 'SUBGERENCIA DE HOME ';
		WHEN '79 ' THEN SET vOut = 'SUB-GERENCIA DE ESTUDIOS ';
		WHEN '80 ' THEN SET vOut = 'VICEPRESIDENCIA COMERCIA ';
		WHEN '81 ' THEN SET vOut = 'GERENCIA GENERAL ';
		WHEN '82 ' THEN SET vOut = 'GERENCIA DE OPERACIONES ';
		WHEN '83 ' THEN SET vOut = 'VICEPRESIDENCIA TECNICA ';
		WHEN '84 ' THEN SET vOut = 'ACTUARIADO ';
		WHEN '85 ' THEN SET vOut = 'VICEPRESIDENCIA DE OPERA ';
		WHEN '86 ' THEN SET vOut = 'SUBGERENCIA DE CASUALTY ';
		WHEN '87 ' THEN SET vOut = 'OPERACIONES CONTROL DE G ';
		WHEN '88 ' THEN SET vOut = 'CALAMA ';
		WHEN '89 ' THEN SET vOut = 'SUBGERENCIA DE SOAP ';
		WHEN '90 ' THEN SET vOut = 'GERENCIA DE SINIESTROS VEHICULOS ';
		WHEN '91 ' THEN SET vOut = 'PROYECTO COMPRA CARTERA ';
		*/
		ELSE SET vOut = '';

	END CASE;
	
	RETURN vOut;
END$$

CREATE FUNCTION fExtraTime2(vMark DATETIME, vLimitTime CHAR(8), vStart BOOLEAN) RETURNS char(100)
BEGIN
	DECLARE vOut CHAR(100) DEFAULT '';
	DECLARE vMinutes INTEGER DEFAULT 0;
	
	SET vMinutes = fExtraTimeAsMins2(vMark, vLimitTime, vStart);
	
	IF(vMinutes != 0) THEN
		SET vOut = TIMESTAMPADD(MINUTE, vMinutes, MAKETIME(0,0,0));
	END IF;

	RETURN vOut;
END$$

CREATE FUNCTION fExtraTimeAsMins2(vMark DATETIME, vLimitTime CHAR(8), vStart BOOLEAN) RETURNS INTEGER
BEGIN
	DECLARE vOut INTEGER DEFAULT 0;
	DECLARE vDateMarkAsString CHAR(100) DEFAULT '';
	DECLARE vDateMark DATETIME;
	
	IF(CHAR_LENGTH(vLimitTime)>0) THEN
		SET vDateMarkAsString = concat(DATE_FORMAT(vMark, '%Y-%m-%d'), ' ', vLimitTime);
		SET vDateMark = STR_TO_DATE(vDateMarkAsString, '%Y-%m-%d %H:%i:%S');

		IF(EXTRACT(HOUR FROM vMark)=23 AND vLimitTime='00:00:00') THEN
			SET vDateMark = TIMESTAMPADD(DAY, 1, vDateMark);
		END IF;
		
		IF(vStart) THEN
			SET vOut = TIMESTAMPDIFF(MINUTE, vMark, vDateMark);
		ELSE
			SET vOut = TIMESTAMPDIFF(MINUTE, vDateMark, vMark);
		END IF;

	END IF;
	
	RETURN vOut;
END$$

CREATE FUNCTION fMarkInTime2(vType INTEGER, vDateTime DATETIME) RETURNS CHAR(8)
BEGIN
	RETURN fGetMarkTime2(vType, vDateTime, 1);
END;

CREATE FUNCTION fMarkOutTime2(vType INTEGER, vDateTime DATETIME) RETURNS CHAR(8)
BEGIN
	RETURN fGetMarkTime2(vType, vDateTime, 4);
END;

CREATE FUNCTION fGetMarkTime2(vTypeAsNum INTEGER, vDateTime DATETIME, vExpected INT) RETURNS CHAR(8)
BEGIN
	DECLARE vOut CHAR(8) DEFAULT '';
	
	IF(vTypeAsNum = vExpected) THEN
		SET vOut = TIME(vDateTime);
	END IF;

	RETURN vOut;
END;

# deprecated
CREATE FUNCTION fSolveType2(pType CHAR) RETURNS CHAR(20)
BEGIN
	DECLARE vOut CHAR(20) DEFAULT '';
	
	CASE pType
		WHEN 'I' THEN SET vOut = 'Entrada';
		WHEN '0' THEN SET vOut = 'Colacion';
		WHEN '1' THEN SET vOut = 'Volver';
		WHEN 'O' THEN SET vOut = 'Salida';
		ELSE SET vOut = '';
	END CASE;
	
	RETURN vOut;
END$$

/**
CREATE FUNCTION fSolveTypeAsNum(pType CHAR) RETURNS INT
BEGIN
	DECLARE vOut INT DEFAULT -1;
	
	CASE pType
		WHEN 'I' THEN SET vOut = 1;
		WHEN '0' THEN SET vOut = 2;
		WHEN '1' THEN SET vOut = 3;
		WHEN 'O' THEN SET vOut = 4;
		ELSE SET vOut = -1;
	END CASE;
	
	RETURN vOut;
END$$
*/

CREATE FUNCTION fLuchTime2(pType CHAR, vDateTime DATETIME) RETURNS CHAR(20)
BEGIN
	DECLARE vOut CHAR(20) DEFAULT '';
	
	IF (pType=2 OR pType=3) THEN
			SET vOut = fTimeFormat2(vDateTime);
	END IF;
	RETURN vOut;
END$$

/**
CREATE FUNCTION fStartTime(pType CHAR, vDateTime DATETIME) RETURNS CHAR(20)
BEGIN
	DECLARE vOut CHAR(20) DEFAULT '';
	DECLARE vType INT DEFAULT 0;
	
	SET vType = fSolveTypeAsNum(pType); 

	IF (vType=1) THEN
			SET vOut = TIME(vDateTime);
	END IF;
	
	RETURN vOut;
END$$
*/

CREATE PROCEDURE pListTurnos2(IN vPerson INT, IN vStarDate DATE, IN vEndDate DATE)
BEGIN
	SELECT	DATE_FORMAT(tAttendanceLog.cDate, '%d/%m/%Y')				AS cDate,
			tMarkType.cName												AS cActivity,
			fLuchTime2(tMarkType.cId, tAttendanceLog.cDate)				AS cLunch,
			fStartTime2(tAttendanceLog.cDate, tEmployee.cId, tMarkType.cId)	AS cInTime,
			fMarkInTime2(tMarkType.cId, tAttendanceLog.cDate)				AS cInMark,
			fExtraTime2(tAttendanceLog.cDate, fStartTime2(tAttendanceLog.cDate, tEmployee.cId, tMarkType.cId), TRUE)	AS cInExtra,
			fEndTime2(tAttendanceLog.cDate, tEmployee.cId, tMarkType.cId) 	AS cOutTime,
			fMarkOutTime2(tMarkType.cId, tAttendanceLog.cDate) 			AS cOutMark,
			fExtraTime2(tAttendanceLog.cDate, fEndTime2(tAttendanceLog.cDate, tEmployee.cId, tMarkType.cId), FALSE)	AS cOutExtra,
			tAttendanceLog.cDate 										AS CHECKTIME,
			fGetJournalString2(tEmployee.cId, tAttendanceLog.cDate)		AS JournalString,

			/*
			tEmployee.cName															AS UserName,
			tEmployee.cRut															AS SSN,
			tUser.BADGENUMBER														AS BADGENUMBER,
*/			
			tArea.cKey													AS DEFAULTDEPTID,
			tArea.cName 												AS cArea,
			fSolveTypeTurno2(tEmployee.cId, tAttendanceLog.cDate)		AS Turno
/*			
			fExtraTimeAsMins(CHECKTIME, fEndTime(CHECKTIME, tInOut.UserId, CHECKTYPE), FALSE)	AS cOutExtraAsMins,
			fExtraTimeAsMins(CHECKTIME, fStartTime(CHECKTIME, tInOut.UserId, CHECKTYPE), TRUE)	AS cInExtraAsMins,
			fDayOfWeek(CHECKTIME)													AS DayOfWeek
 */			
			
	FROM tAttendanceLog
	LEFT JOIN tEmployee	ON tAttendanceLog.cEmployeeKey = tEmployee.cKey
	LEFT JOIN tMarkType	ON tAttendanceLog.cMarkType = tMarkType.cId
	LEFT JOIN tArea		ON tEmployee.cArea = tArea.cId
	WHERE tAttendanceLog.cEmployeeKey=vPerson AND tAttendanceLog.cDate BETWEEN vStarDate AND vEndDate
	ORDER BY tAttendanceLog.cDate;
	
/*	ORDER BY CHECKTIME, fSolveTypeAsNum(CheckType);
	limit 50;*/
	
	/*WHERE Checkinout.USERID=vPerson AND Userinfo.USerid=vPerson AND CHECKtime BETWEEN vStarDate AND vEndDate*/

END$$

DELIMITER ;

/*
call pListTurnos(1, '2014-01-01', '2014-07-31');
call pListTurnos(4, '2013-01-01', '2014-01-31');
call pListTurnos(5, '2013-01-01', '2014-01-31');
call pListTurnos(7, '2013-01-01', '2014-01-31');
*/

#call pListTurnos(7, '2013-01-20', '2014-07-30');

/*
select fExtraTimeAsMins('2014-01-20 19:00:00' , '19:00:00', true);
select fExtraTimeAsMins('2014-01-20 19:00:00' , '19:12:00', true);
select fExtraTimeAsMins('2014-01-20 00:00:00' , '00:00:00', true);
select fExtraTimeAsMins('2014-01-20 00:50:00' , '00:00:00', true);
select fExtraTimeAsMins('2014-01-19 23:50:00' , '00:00:00', true);
*/

#select fResolveTime('16:00:00', '2014-01-01 15:46:38');

#call pListTurnosAsExcel('2014-06-01', '2014-06-05');

#select DAYOFWEEK('1975-05-30');

/*
select fResolveTime('16:00:00', '2014-01-31 15:10:22');
select fResolveTime('16:00:00', '2014-01-31 16:10:22');
select fResolveTime('00:00:00', '2014-01-31 23:10:22');
select fResolveTime('00:00:00', '2014-01-31 00:10:22');
select fResolveTime('12:00:00', '2014-01-31 00:10:22');


fGetLimitTime();

(vMarkTime DATETIME, vUserId INT, vType CHAR(1), vExpectedType INT)
*/