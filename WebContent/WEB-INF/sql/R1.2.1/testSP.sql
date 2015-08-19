#call pListReportInputParameter(1);

#call pListAttendance3(50, '2015-02-05', '2015-02-05');
#call pListAttendance3(50, '2015-02-06', '2015-02-06');
#call pListAttendance3(9, '2015-01-22', '2015-01-22');
#call pListAttendance3(10, '2015-01-16', '2015-01-16');
#call pListAttendance3(12, '2014-12-02', '2014-12-02');
#call pListAttendance3(12, '2014-12-17', '2014-12-17');
#call pListAttendance3(9, '2015-02-22', '2015-02-22');
#call pListAttendance3(14, '2014-10-25', '2014-10-25');
#call pListAttendance3(12, '2014-12-17', '2014-12-17');
#call pListAttendance3(14, '2014-10-26', '2014-10-26');
#call pListAttendance3(14, '2014-10-26', '2014-10-26');
#call pListAttendance3(12, '2014-12-18', '2014-12-18');

#20
#call pListAttendance3(14, '2014-10-26', '2014-10-26');
#21
#call pListAttendance3(20, '2015-03-04', '2015-03-04');
#22
#call pListAttendance3(63, '2014-11-07', '2014-11-07');


#select fFindTurn(8, '2015-02-05 23:53:51');

#select fMarkAndUserToTurnDayId4( '2015-01-01', 61, 180);
#select fMarkAndUserToTurnDayId4( '2015-01-01', 70, 180);
#select fMarkAndUserToTurnDayId4( '2015-01-01', 62, 180);

#select concat('+', fIsFlexible('2015-01-01', 61), '+');
#select concat('+', fIsFlexible('2015-01-01', 70), '+');
#select concat('+', fIsFlexible('2015-01-01', 62), '+');

#call pListLater ('2014-11-01','2014-11-30');

call pListAttendance3(50, '2015-03-22', '2015-03-24');
