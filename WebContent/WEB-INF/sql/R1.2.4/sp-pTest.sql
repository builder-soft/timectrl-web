DROP PROCEDURE if exists pTest;
DROP PROCEDURE if exists pSplit;

DELIMITER $$

CREATE PROCEDURE pTest(IN vIds VARCHAR(50))
BEGIN
	SELECT	cid, cName 
	FROM 	tEmployee
#	WHERE	cId IN (pSplit(vIds));
	WHERE	pSplit(vIds) IN (cId);
#	select 1;
END$$

CREATE PROCEDURE pSplit(IN str VARCHAR(50))
BEGIN
	DECLARE vEnd BOOLEAN DEFAULT FALSE;
	DECLARE vIndex INTEGER DEFAULT 0;
	DECLARE vPos INTEGER DEFAULT 0;
	DECLARE vValue VARCHAR(50) DEFAULT '';

	DROP TEMPORARY TABLE IF EXISTS tTempSplit;
	CREATE TEMPORARY TABLE tTempSplit (
		cId 				BIGINT(20) NOT NULL auto_increment,
		cValue				VARCHAR(50) NULL,
		PRIMARY KEY (cId)
    ) Engine=memory;

   	select vIndex, vPos, str;
    
    WHILE (NOT vEnd) DO
    	SET vPos = INSTR(str, ',');
    	SET vValue = SUBSTR(str, vIndex+1, vPos-1);
    	SET str = SUBSTR(str, vPos+1);
    	SET vIndex = vPos; #INSTR(str, ',');
    	
    	select vIndex, vPos, str;
    	
    	IF(LENGTH(str)=0 OR vPos = 0) THEN
    		SET vEnd = TRUE;
    	END IF;
    	
    	INSERT INTO tTempSplit(cValue) VALUES(vValue);
    	
#    	SET vEnd = TRUE;
    END WHILE;
    
	SELECT	cValue 
	FROM 	tTempSplit;
	DROP TEMPORARY TABLE IF EXISTS tTempSplit;
END$$

#DROP PROCEDURE IF EXISTS pTest$$

DELIMITER ;


