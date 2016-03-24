
SELECT DATE('2003-12-31 01:02:03');
SELECT DATE('2003-12-31 01:02:03.1234');
SELECT DATE('01:02:03');


select date(datetimetz'2000-12-31 17:34:23.1234'), if (date(datetimetz'2000-12-31 17:34:23.1234') = '12/31/2000', 'ok', 'nok');
select date(timestamptz'2000-12-31 17:34:23'), if (date(timestamptz'2000-12-31 17:34:23') = '12/31/2000', 'ok', 'nok');
