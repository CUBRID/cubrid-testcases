/* test datetime */
select date_format(datetime '2/12/2012 23:59:59', '%W %M %Y %TZR %TZH %TZM %TZD');
select date_format(datetime '2009-10-04 22:23:00', '%W %TZR %TZD %M %TZH %Y %TZM');

/* test timestamp */
select date_format(timestamp '2/12/2012 23:59:59', '%W %M %Y %TZR %TZH %TZM %TZD');
select date_format(timestamp '2009-10-04 22:23:00', '%W %TZR %TZD %M %TZH %Y %TZM');

/* test timezone parameters with string formated as datetimetz */
select date_format('2009-10-04 22:23:00', '%W %M %Y %TZR %TZH %TZM');
select date_format('2012-02-02 10:10:10 Europe/Vienna', '%TZR %TZD %TZH %TZM');
select date_format('2012-02-02 10:10:10 Europe/Viennaa', '%TZR %TZD %TZH %TZM');
select date_format('2012-02-02 10:10:10 Europe/Viennaa', '%W %M %Y');
select date_format('2012-02-02 10:10:10 Europe/Zurich CET', '%TZR %TZD %TZH %TZM');
select date_format('2012-02-02 10:10:10 Europe/Zurich CEST', '%TZR %TZD %TZH %TZM');
select date_format('2012-02-02 10:10:10 Asia/Seoul', '%TZD');
select date_format('2009-10-04 22:23:00 Europe/London', '%W %TZR %TZD %M %TZH %Y %TZM');

/* test datetimetz */
select date_format(datetimetz '2/12/2012 23:59:59', '%W %M %Y %TZR %TZH %TZM');
select date_format(datetimetz '2009-10-04 22:23:00 Europe/Paris', '%W %TZR %TZD %M %TZH %Y %TZM');

/* test datetimeltz */
select date_format(datetimeltz '2/12/2012 23:59:59', '%W %M %Y %TZR %TZH %TZM %TZD');

/* test timestamptz */
select date_format(timestamptz '2/12/2012 23:59:59', '%W %M %Y %TZR %TZH %TZM');
select date_format(timestamptz '2009-10-04 22:23:00 Europe/Paris', '%W %TZR %TZD %M %TZH %Y %TZM');

/* test timestampltz */
select date_format(timestampltz '2/12/2012 23:59:59', '%W %M %Y %TZR %TZH %TZM %TZD');

/* complex tests */
select date_format(to_datetime_tz('2/12/2012 23:59:59'), '%TZR %TZD %TZH %TZM');
select date_format(to_datetime_tz('08-Dec-25 13:10:30.999 Europe/Vienna CET', 'YY-Mon-DD HH24:MI:SS.FF TZR TZD'), '%W %M %Y %TZR %TZD %TZH %TZM');

select date_format(to_timestamp_tz('2/12/2012 23:59:59'), '%TZR %TZD %TZH %TZM');
select date_format(to_timestamp_tz('08-Dec-25 13:10:30 Europe/Vienna CET', 'YY-Mon-DD HH24:MI:SS TZR TZD'), '%W %M %Y %TZR %TZD %TZH %TZM');
