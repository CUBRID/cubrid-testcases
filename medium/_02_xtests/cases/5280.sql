

autocommit off;
create class foo (mset multiset(double, monetary, date, time, utime));
insert into foo values ({time'12:20:18'});
insert into foo values ({time'12:25 PM'});
insert into foo values ({time'12:25 PM' + 0});
insert into foo values ({time'12:25 PM' + 1});
select * from foo order by case
  when time'12:20:18' in mset then 1
  when time'12:25 PM' in mset then 2
  when time'12:25 PM' + 1 in mset then 3
  else 4
end;
rollback;

set system parameters 'compat_mode=mysql';

autocommit off;
create class foo (mset multiset(double, monetary, date, time, utime));
insert into foo values ({time'12:20:18'});
insert into foo values ({time'12:25 PM'});
insert into foo values ({time'12:25 PM' + 0});
insert into foo values ({time'12:25 PM' + 1});
select * from foo order by case
  when time'12:20:18' in mset then 1
  when time'12:25 PM' in mset then 2
  else 3
end;
rollback;

set system parameters 'compat_mode=cubrid';
