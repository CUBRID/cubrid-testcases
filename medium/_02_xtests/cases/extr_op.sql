autocommit off;
/* client side calls */
select extract(day from null)
from class db_user;
select extract(hour from time '11:22:33' + null)
from class db_user;
select extract(hour from time '11:22:33')
from class db_user;
select extract(minute from time '11:22:33')
from class db_user;
select extract(second from time '11:22:33')
from class db_user;
select extract(hour from time '11:22:33 pm')
from class db_user;
select extract(year from date '08/01/1996')
from class db_user;
select extract(month from date '08/01/1996')
from class db_user;
select extract(day from date '08/01/1996')
from class db_user;
select extract(hour from timestamp '11:22:33 08/01/1996')
from class db_user;
select extract(minute from timestamp '11:22:33 08/01/1996')
from class db_user;
select extract(second from timestamp '11:22:33 08/01/1996')
from class db_user;
select extract(hour from timestamp '11:22:33 pm 08/01/1996')
from class db_user;
select extract(year from timestamp '11:22:33 08/01/1996')
from class db_user;
select extract(month from timestamp '11:22:33 08/01/1996')
from class db_user;
select extract(day from timestamp '11:22:33 08/01/1996')
from class db_user;
select extract(second from time '11:22:33' + 11)
from class db_user;
select extract(day from date '08/01/1996' - 11)
from class db_user;
select extract(second from timestamp '11:22:33 08/01/1996' + 22)
from class db_user;
select extract(hour from cast('11:12:13' as time))
from class db_user;
/* server side calls */
create class x (x1 string, 
		x2 time, 
		x3 date, 
		x4 timestamp);
create class y (y1 int);
insert into x (x1, x4) values ('Utime (x4) only', 
			       timestamp '11:22:33 09/02/1997');
insert into x (x1, x3) values ('Date (x3) only', date '09/02/1997');
insert into x (x1, x2) values ('Time (x2) only', time '11:22:33');
insert into x values ('All (x2, x3, x4)',
		      time '01:02:03', 
		      date '08/01/1996', 
		      timestamp '01:02:03 08/01/1996');
insert into y values (5);
select x1, x2, extract(hour from x2) from x where x1 = 'Date (x3) only';
select x1, x2, extract(hour from x2) from x;
select x1, x2, extract(minute from x2) from x;
select x1, x2, extract(second from x2) from x;
select x1, x3, extract(year from x3) from x;
select x1, x3, extract(month from x3) from x;
select x1, x3, extract(day from x3) from x;
select x1, x4, extract(hour from x4) from x;
select x1, x4, extract(minute from x4) from x;
select x1, x4, extract(second from x4) from x;
select x1, x4, extract(year from x4) from x;
select x1, x4, extract(month from x4) from x;
select x1, x4, extract(day from x4) from x;
select x2, y1, extract(second from x2 + y1) from x, y where x2 is not null;
select x2, y1, extract(minute from x2 - y1) from x, y where x2 is not null;
select x2, y1, extract(second from x2 - y1) from x, y where x2 is not null;
select x3, y1, extract(month from x3 + y1), extract(day from x3 + y1)
from x, y where x3 is not null;
select x3, y1, extract(month from x3 - y1), extract(day from x3 - y1)
from x, y where x3 is not null;
select x4, y1, extract(second from x4 + y1) from x, y where x4 is not null;
select x4, y1, extract(minute from x4 - y1) from x, y where x4 is not null;
select x4, y1, extract(second from x4 - y1) from x, y where x4 is not null;
select x3, extract(hour from cast(x3 as timestamp)) from x;
rollback;

set system parameters 'compat_mode=mysql';

autocommit off;
/* client side calls */
select extract(day from null)
from class db_user;
select extract(hour from time '11:22:33' + null)
from class db_user;
select extract(hour from time '11:22:33')
from class db_user;
select extract(minute from time '11:22:33')
from class db_user;
select extract(second from time '11:22:33')
from class db_user;
select extract(hour from time '11:22:33 pm')
from class db_user;
select extract(year from date '08/01/1996')
from class db_user;
select extract(month from date '08/01/1996')
from class db_user;
select extract(day from date '08/01/1996')
from class db_user;
select extract(hour from timestamp '11:22:33 08/01/1996')
from class db_user;
select extract(minute from timestamp '11:22:33 08/01/1996')
from class db_user;
select extract(second from timestamp '11:22:33 08/01/1996')
from class db_user;
select extract(hour from timestamp '11:22:33 pm 08/01/1996')
from class db_user;
select extract(year from timestamp '11:22:33 08/01/1996')
from class db_user;
select extract(month from timestamp '11:22:33 08/01/1996')
from class db_user;
select extract(day from timestamp '11:22:33 08/01/1996')
from class db_user;
select extract(second from time '11:22:33' + 11)
from class db_user;
select extract(day from date '08/01/1996' - 11)
from class db_user;
select extract(second from timestamp '11:22:33 08/01/1996' + 22)
from class db_user;
select extract(hour from cast('11:12:13' as time))
from class db_user;
/* server side calls */
create class x (x1 string, 
		x2 time, 
		x3 date, 
		x4 timestamp);
create class y (y1 int);
insert into x (x1, x4) values ('Utime (x4) only', 
			       timestamp '11:22:33 09/02/1997');
insert into x (x1, x3) values ('Date (x3) only', date '09/02/1997');
insert into x (x1, x2) values ('Time (x2) only', time '11:22:33');
insert into x values ('All (x2, x3, x4)',
		      time '01:02:03', 
		      date '08/01/1996', 
		      timestamp '01:02:03 08/01/1996');
insert into y values (5);
select x1, x2, extract(hour from x2) from x where x1 = 'Date (x3) only';
select x1, x2, extract(hour from x2) from x;
select x1, x2, extract(minute from x2) from x;
select x1, x2, extract(second from x2) from x;
select x1, x3, extract(year from x3) from x;
select x1, x3, extract(month from x3) from x;
select x1, x3, extract(day from x3) from x;
select x1, x4, extract(hour from x4) from x;
select x1, x4, extract(minute from x4) from x;
select x1, x4, extract(second from x4) from x;
select x1, x4, extract(year from x4) from x;
select x1, x4, extract(month from x4) from x;
select x1, x4, extract(day from x4) from x;
select x2, y1, extract(second from x2 + y1) from x, y where x2 is not null;
select x2, y1, extract(minute from x2 - y1) from x, y where x2 is not null;
select x2, y1, extract(second from x2 - y1) from x, y where x2 is not null;
select x3, y1, extract(month from x3 + y1), extract(day from x3 + y1)
from x, y where x3 is not null;
select x3, y1, extract(month from x3 - y1), extract(day from x3 - y1)
from x, y where x3 is not null;
select x4, y1, extract(second from x4 + y1) from x, y where x4 is not null;
select x4, y1, extract(minute from x4 - y1) from x, y where x4 is not null;
select x4, y1, extract(second from x4 - y1) from x, y where x4 is not null;
select x3, extract(hour from cast(x3 as timestamp)) from x;
rollback;

set system parameters 'compat_mode=cubrid';

