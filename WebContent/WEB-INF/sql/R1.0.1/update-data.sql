/*
0-Check-In (default value) 1-Check-Out 2-Break-Out 3-Break-In 4-OT-In 5-OT-Out 
*/
UPDATE tMarkType SET cKey = '0' WHERE cId=1;
UPDATE tMarkType SET cKey = '2' WHERE cId=2;
UPDATE tMarkType SET cKey = '3' WHERE cId=3;
UPDATE tMarkType SET cKey = '1' WHERE cId=4;
INSERT INTO tMarkType(cKey, cName) VALUES('4', 'Otra entrada');
INSERT INTO tMarkType(cKey, cName) VALUES('5', 'Otra salida');

UPDATE tParameter SET cValue='dd-MM-yyyy HH:mm:ss' WHERE cKey = 'FORMAT_DATETIME';
