--UNIX_TIMESTAMP() default value for date/time column.


--date column
drop table if exists t1,t2,t3;
create table t1(a date default CURRENT_TIMESTAMP);
--[er] UNIX_TIMESTAMP() cannot be converted to date type
create table t2(a date default UNIX_TIMESTAMP());
create table t3(a date default SYSTIMESTAMP);

show columns in t1;
desc t3;

drop table if exists t1, t2, t3;


--time column
drop table if exists foo;
create table foo(
	a time default CURRENT_TIMESTAMP,
	b time default UNIX_TIMESTAMP(),
	c time default SYSTIMESTAMP
);

show columns in foo;
insert into foo default;
select if((time(SYSTIMESTAMP) - a) < 2 and (time(SYSTIMESTAMP) - c) < 2, 'ok', 'nok') from foo;


drop table foo;
