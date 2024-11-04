--TEST: string of date/time format is not supported in width_bucket() function.


drop if exists foo;
create table foo(a varchar);
insert into foo values('2012-12-12');
insert into foo values('2011-12-20');
insert into foo values(NULL);
select width_bucket(a, '2011-12-12', '2012-12-31', 3) from foo order by 1;
prepare s from 'select width_bucket(a, ?, ?, 3) from foo order by 1';
execute s using '2011-12-12', '2012-12-31';
execute s using '2011-12-12', '2012';
execute s using '2011-12-12', NULL;
execute s using date'2011-12-12', '2012-12-31';
deallocate prepare s;
drop if exists foo;

create table foo(a varchar);
insert into foo values('2012-12-12 0:12:23');
insert into foo values('2011-12-20 23:34:45');
insert into foo values(NULL);
select width_bucket(a, '2011-12-12 0:0:0', '2012-12-31 1:2:3', 3) from foo order by 1;
prepare s from 'select width_bucket(a, ?, ?, 3) from foo order by 1';
execute s using '2011-12-12 0:0:0', '2012-12-31 1:2:3';
execute s using '2011-12-12  0:0:0', '2012';
execute s using '2011-12-12  0:0:0', NULL;
execute s using datetime'2011-12-12 0:0:0', '2012-12-31';
deallocate prepare s;
drop if exists foo;

create table foo(a varchar);
insert into foo values('0:12:23');
insert into foo values('23:34:45');
insert into foo values(NULL);
select width_bucket(a, '0:0:0', '23:59:59', 3) from foo order by 1;
prepare s from 'select width_bucket(a, ?, ?, 3) from foo order by 1';
execute s using '0:0:0', '23:59:59';
execute s using '0:0:0', '2012';
execute s using '0:0:0', NULL;
execute s using time'0:0:0', '23:59:59';
deallocate prepare s;
drop if exists foo;

create table foo(a varchar);
insert into foo values('2012');
insert into foo values('2016');
insert into foo values(NULL);
select width_bucket(a, '2000', '2020', 10) from foo order by 1;
prepare s from 'select width_bucket(a, ?, ?, 3) from foo order by 1';
execute s using '2000', '2020';
execute s using '2011-12-12', '2012';
execute s using '2000', NULL;
execute s using 2000, '2020';
deallocate prepare s;
drop if exists foo;


