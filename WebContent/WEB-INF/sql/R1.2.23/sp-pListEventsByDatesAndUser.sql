DROP PROCEDURE IF EXISTS pListEventsByDatesAndUser;

DELIMITER $$

CREATE PROCEDURE pListEventsByDatesAndUser(IN vStartDate DATE, IN vEndDate DATE, IN vUserId BIGINT(20))
BEGIN
	SELECT	a.cWhen AS cWhen, a.cUser AS cUser, b.cName AS cUserName, b.cMail AS cUserMail, a.cEventType AS cEventType, c.cName AS cEventTypeName, a.cWhat AS cWhat
	FROM	tEvent AS a
	LEFT JOIN bsframework.tUser AS b ON a.cUser = b.cId
	LEFT JOIN tEventType AS c ON a.cEventType = c.cId
	WHERE	DATE(cWhen) BETWEEN vStartDate AND vEndDate
			AND b.cId = vUserId
	ORDER BY cWhen DESC;
	
END$$