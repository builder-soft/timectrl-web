DROP PROCEDURE if exists pReadWeeksOfMonth;

DELIMITER $$

CREATE PROCEDURE pReadWeeksOfMonth(IN vMonth INTEGER, IN vYear INTEGER)
BEGIN
	DECLARE vCurrent	DATE;
	DECLARE vLast		DATE;
	DECLARE vFirst		DATE;
	DECLARE vFirstLoop	BOOLEAN DEFAULT TRUE;
	DECLARE vMonday		DATE; /* Lunes   */
	DECLARE vSunday		DATE; /* Domingo */
	
	SET vFirst = DATE(CONCAT(vYear, '-', vMonth, '-01'));
	SET vCurrent = vFirst;
	SET vLast = LAST_DAY(vFirst);
	
	CREATE TEMPORARY TABLE tWeek (
		cStart	DATE  NOT NULL,
		cEnd	DATE  NOT NULL
    );
	
	WHILE vCurrent <= vLast DO
		IF(vFirstLoop) THEN
			SET vMonday = vCurrent;
			SET vFirstLoop = FALSE;
		END IF;
	
		IF(DAYOFWEEK(vCurrent)=1) THEN /* 1=Domingo, 2=Lunes */
			SET vSunday = vCurrent;
		ELSE
			IF(DAYOFWEEK(vCurrent)=2) THEN
				SET vMonday = vCurrent;
			END IF;
		END IF;
		
		IF(vCurrent = vLast) THEN
			SET vSunday = vCurrent;
		END IF;
		
		IF((IFNULL(vMonday, 0) != 0 AND IFNULL(vSunday, 0) != 0) OR vCurrent = vLast) THEN
			INSERT INTO tWeek(cStart, cEnd) VALUES(vMonday, vSunday);
			SET vMonday = NULL;
			SET vSunday = NULL;
		END IF;
/*
		IF(vFirst = vCurrent) THEN
#				INSERT INTO tWeek(cStart, cEnd) VALUES();
		
			SET vFirstLoop = FALSE;
		END IF;
		*/
		
		SET vCurrent = DATE_ADD(vCurrent, INTERVAL 1 DAY);
	END WHILE;

	SELECT cStart, cEnd FROM tWeek;
	
	DROP TABLE tWeek;
END$$

DELIMITER ;
