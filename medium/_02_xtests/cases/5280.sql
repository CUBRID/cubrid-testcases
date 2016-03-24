

autocommit off;
create class foo (mset multiset(double, monetary, date, time, utime));
insert into foo values ({time'12:20:18'});
insert into foo values ({time'12:25 PM'});
insert into foo values ({time'12:25 PM' + 0});
insert into foo values ({time'12:25 PM' + 1});
select * from foo;
rollback;

set system parameters 'compat_mode=mysql';

autocommit off;
create class foo (mset multiset(double, monetary, date, time, utime));
insert into foo values ({time'12:20:18'});
insert into foo values ({time'12:25 PM'});
insert into foo values ({time'12:25 PM' + 0});
insert into foo values ({time'12:25 PM' + 1});
select * from foo;
rollback;

set system parameters 'compat_mode=cubrid';

