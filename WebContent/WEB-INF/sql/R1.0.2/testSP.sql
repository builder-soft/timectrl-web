/*** DATOS PARA HACER PRUEBAS BASICAS *****************/

DELIMITER $$

/********************************/

#select fGetJournalString2(1, '2014-07-15');
#select fGetLimitTime2('2014-07-15 19:39:29', 1,4,4);

#call pListTurnos2(76, '2014-06-01', '2014-08-30')
#call pAbsence('2014-06-13');

#select fExtraTime('2014-07-01 19:39:29', );

#call pListAttendance3(1, '2014-05-01', '2014-05-31');
#call pListAttendance3(1, '2014-07-01', '2014-07-31');
#call pListAttendance3(2, '2014-07-01', '2014-07-31');
call pListAttendance3(1, '2014-08-01', '2014-08-31');


#call pListAttendanceAsExcel3('2014-07-01', '2014-07-01');

#call pGetEmployeeInfo(1);

#call pReadWeeksOfMonth(8,2014);
#call pReadWeeksOfMonth(7,2014);
#call pReadWeeksOfMonth(6,2014);
#call pReadWeeksOfMonth(5,2014);

#call pOvertime(6,2014,10);
#call pListMarkOfEmployee(10, '2014-06-01', '2014-06-07');
#select carea, count(carea) as conteo from temployee group by carea order by conteo ;
/*
SELECT * FROM tAttendanceLog where cemployeekey = '300' AND DATE(cDate) between DATE('2014-07-17')  and DATE('2014-07-17')

SELECT * FROM tAttendanceLog 
WHERE cEmployeeKey = '300' AND DATE(cDate) = DATE('2014-07-17') AND TIME(cDate) BETWEEN TIMESTAMPADD(MINUTE, (vMinutes*-1), TIME('18:00')) AND TIMESTAMPADD(MINUTE, vMinutes, TIME('18:00'))
*/