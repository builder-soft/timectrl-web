/*** DATOS PARA HACER PRUEBAS BASICAS *****************/

/********************************/

#call pListAttendanceAsExcel3('2014-09-18', '2014-09-19');

#call pListAttendance3(1, '2014-05-01', '2014-05-31');
#call pListAttendance3(1, '2014-07-01', '2014-07-31');
#call pListAttendance3(2, '2014-07-01', '2014-07-31');
#call pListAttendance3(1, '2014-08-01', '2014-08-31');
#call pListAttendance3(1, '2014-09-15', '2014-08-21');

#call pAbsence('2014-06-13');

#select fExtraTimeAsMins4('2014-10-01 19:30:00', '19:00', FALSE, '2014-10-01');
#select fExtraTimeAsMins4('2014-10-01 18:30:00', '19:00', FALSE, '2014-10-01');
#select fExtraTimeAsMins4('2014-10-02 01:30:00', '19:00', FALSE, '2014-10-01');
#select fExtraTimeAsMins4('2014-10-02 00:01:00', '19:00', FALSE, '2014-10-01');
#select fExtraTimeAsMins4('2014-10-07 01:36:03', '18:15', FALSE, '2014-09-01');

call pListAttendanceAsExcel3('2014-09-01', '2014-09-03');

