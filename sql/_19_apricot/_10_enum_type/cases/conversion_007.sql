--
create table t1(e1 enum ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'), e2 enum('02/23/2012', '12/21/2012'), e3 enum('11:12:09', '13:13:13'), e4 enum('123', '9876', '-34'));
insert into t1 values(2, 1, 1, 2), (5, 2, 1, 1), (6, 2, 2, 3), (1, 1, 1, 2), (7, 1, 2, 3), (4, 2, 2, 2), (3, 1, 1, 1);

--operators
select e1 + 1, 1 + e1, e1 + 1.1 from t1 where e1 < 7 order by 1, 2, 3;
select e1 * 5 from t1 order by 1;
select e1 + '-' from t1 order by 1;

--strings
select repeat(e1, 2) from t1 order by 1;
select reverse(e1) from t1 order by 1;
select substring(e1, cast(e1 as int), 1) from t1 order by 1;
select concat(e1, ' * ', e2, ' * ', e3, ' * ') from t1 order by 1;

--numeric
select repeat('*', e1) from t1 order by 1;

--date/time
select year(e2), month(e2), day(e2) from t1 order by 1, 2, 3;

--aggregate
select sum(e1) from t1 order by 1;
select bit_and(e1), bit_or(e1) from t1 order by 1;

--bit functions
select bit_count(e1) from t1 order by 1;
select e1 | e2 from t1 order by 1;

--data type conversions
select date_format(e2, '%Y.%m.%d') from t1 order by 1;
select time_format(e3, '%H_%I_%S') from t1 order by 1;
select to_char(e1) from t1 order by 1;
select to_char(e2) from t1 order by 1;
select to_date(e1) from t1 order by 1;
select to_date(e2) from t1 order by 1;
select to_number(e1) from t1 order by 1;
select to_number(e4) from t1 order by 1;
select to_time(e1) from t1 order by 1;
select to_time(e3) from t1 order by 1;
select to_timestamp(e2) from t1 order by 1;
select to_timestamp(e3) from t1 order by 1;

--conditional expressions
select * from t1 where e1 in (1, 2, 4, 7) order by 1, 2, 3, 4;
select * from t1 where e1 in ('Tuesday', 'Thursday', 'Sunday') order by 1, 2, 3, 4;

--session variables
select @v1:=e1 from t1 where e1=2 order by 1;
select @v1;
drop variable @v1;

drop table t1;