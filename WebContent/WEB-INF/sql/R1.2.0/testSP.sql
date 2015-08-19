#call pListLater ('2014-11-01','2014-11-30');

#call pListAttendanceAsExcel3('2013-07-19', ' 2015-03-05');

#select fInferTime(NULL);
#select concat('+', fResolveTime('00:00', NULL), '+');
#call pListAttendance3(3, '2014-07-03', '2015-02-28');
#call pListAttendance3(6, '2014-08-12', '2014-08-12');
#call pListAttendance3(2, '2015-01-07', '2015-01-07');
#call pListAttendance3(2, '2015-01-14', '2015-01-14');
#call pListAttendance3(51, '2015-02-14', '2015-02-14');
#call pListAttendance3(51, '2015-02-20', '2015-02-20');
#call pListAttendance3(10, '2015-01-14', '2015-01-17');
#call pListAttendance3(12, '2014-12-18', '2014-12-18');
#call pListAttendance3(12, '2015-02-23', '2015-02-23');
call pListAttendance3(19, '2015-04-06', '2015-04-10');
#call pListAttendanceAsExcel3('2015-01-01', '2015-01-15');


#call pListAttendance3(14, '2014-07-03', '2015-02-28');
#call pListAttendanceAsExcel3('2014-07-03', '2015-02-28');
#call pListAttendanceAsExcel3('2014-10-12', '2014-10-12');
# 2014-07-03 | 15899587-2

/*
select fResolveTime('08:00:00', '2014-07-03 07:50:00');
select fResolveTime('08:00:00', '2014-07-03 09:10:00');
select fResolveTime('00:00:00', '2014-07-03 23:50:00');
select fResolveTime('00:00:00', '2014-07-03 22:50:00');
select fResolveTime('00:00:00', '2014-07-03 01:50:00');
select fResolveTime('00:00:00', '2015-02-28 21:50:00');
*/
#select fInferTime('2014-08-12 09:02:18');
#select fInferTime('2014-10-11 22:54:40');
#select 1;
#select fResolveTime('00:00:00', '2014-10-11 22:54:40');
#select 2;

#select fStartMark(303, 180, '2014-12-18', NULL, NULL, 15);


