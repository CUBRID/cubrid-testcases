/* test datetime */
select to_char(datetime '2/12/2012 23:59:59', 'HH24:MI, DD, MONTH, YYYY TZR TZH TZM TZD');
select to_char(datetime '2/12/2012 23:59:59', 'HH24:MI, TZR, DD, TZH, MONTH, YYYY, TZM TZD');

/* test timestamp */
select to_char(timestamp '2/12/2012 23:59:59', 'HH24:MI, DD, MONTH, YYYY TZR TZH TZM TZD');
select to_char(timestamp '2/12/2012 23:59:59', 'HH24:MI, TZR, DD, TZH, MONTH, YYYY, TZM TZD');

/* test time */
select to_char(time '23:59:59', 'HH24:MI:SS TZR TZH TZM TZD');
select to_char(time '23:59:59', 'TZR HH24:MI TZH SS TZM TZD');

/* test datetimetz */

/* without format */
select to_char(datetimetz '2/12/2012 23:59:59');
select to_char(datetimetz '2/12/2012 23:59:59 Europe/Zurich CET');
select to_char(datetimetz '2/12/2012 23:59:59 Europe/Zurich CEST');

/* with format */
select to_char(datetimetz '2/12/2012 23:59:59', 'TZR TZH TZM');
select to_char(datetimetz '2/12/2012 23:59:59 Europe/Paris CET', 'HH24:MI, DD, MONTH, YYYY TZR TZD TZH TZM');
select to_char(datetimetz '2/12/2012 23:59:59 Europe/Paris CET', 'HH24:MI, DD, TZR ,MONTH, TZD, YYYY TZH TZM');
select to_char(datetimetz '2/12/2012 23:59:59 Europe/Paris CEST', 'HH24:MI, DD, MONTH, YYYY TZR TZD TZH TZM');

/* test datetimeltz */

/* without format */
select to_char(datetimeltz '4/05/2005 23:59:59');

/* with format */
select to_char(datetimeltz '2/12/2012 23:59:59', 'TZR TZH TZM');
select to_char(datetimeltz '2/12/2012 23:59:59', 'HH24:MI, DD, MONTH, YYYY TZR TZD TZH TZM');
select to_char(datetimeltz '11/05/2016 23:59:59', 'HH24:MI, DD, TZR ,MONTH, TZD, YYYY TZH TZM');

/* test timestamptz */

/* without format */
select to_char(timestamptz '2/12/2012 23:59:59');
select to_char(timestamptz '2/12/2012 23:59:59 Europe/Zurich CET');
select to_char(timestamptz '2/12/2012 23:59:59 Europe/Zurich CEST');

/* with format */
select to_char(timestamptz '2/12/2012 23:59:59', 'TZR TZH TZM');
select to_char(timestamptz '2/12/2012 23:59:59 Europe/Paris CET', 'HH24:MI, DD, MONTH, YYYY TZR TZD TZH TZM');
select to_char(timestamptz '2/12/2012 23:59:59 Europe/Paris CET', 'HH24:MI, DD, TZR ,MONTH, TZD, YYYY TZH TZM');
select to_char(timestamptz '2/12/2012 23:59:59 Europe/Paris CEST', 'HH24:MI, DD, MONTH, YYYY TZR TZD TZH TZM');

/* test timestampltz */

/* without format */
select to_char(timestampltz '4/05/2005 23:59:59');

/* with format */
select to_char(timestampltz '2/12/2012 23:59:59', 'TZR TZH TZM');
select to_char(timestampltz '2/12/2012 23:59:59', 'HH24:MI, DD, MONTH, YYYY TZR TZD TZH TZM');
select to_char(timestampltz '11/05/2016 23:59:59', 'HH24:MI, DD, TZR ,MONTH, TZD, YYYY TZH TZM');

/* test timetz */

/* without format */
select to_char(time '23:59:59');
select to_char(time '23:59:59 Asia/Shanghai CST');

/* with format */
select to_char(time '23:59:59', 'TZR TZH TZM');

/* complex tests */
select to_char(to_datetime_tz('2/12/2012 23:59:59'), 'TZR TZD TZH TZM');
select to_char(to_datetime_tz('08-Dec-25 13:10:30.999 Europe/Vienna CET', 'YY-Mon-DD HH24:MI:SS.FF TZR TZD'), 'HH24:MI, DD, MONTH, YYYY TZR TZD TZH TZM');

select to_char(to_timestamp_tz('2/12/2012 23:59:59'), 'TZR TZD TZH TZM');
select to_char(to_timestamp_tz('08-Dec-25 13:10:30 Europe/Vienna CET', 'YY-Mon-DD HH24:MI:SS TZR TZD'), 'HH24:MI, DD, MONTH, YYYY TZR TZD TZH TZM');

select to_char(to_time_tz('23:59:59'), 'TZR TZD TZH TZM');
select to_char(to_time_tz('13:10:30 Africa/Bamako GMT'), 'HH24:MI:SS TZR TZD');
