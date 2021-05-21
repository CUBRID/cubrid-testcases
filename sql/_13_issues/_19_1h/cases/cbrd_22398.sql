drop if exists tb1,tb2,foo,t1;
create class tb1 ( a set(char(2)));
create class tb2 ( b set(nchar(2)));
insert into tb1 values({'a1'});
insert into tb2 values({n'a1'});
select a,b from tb1, tb2 where a seteq b order by 1,2;
create table foo as WITH cte AS
(
select a,b from tb1, tb2 where a setneq b order by 1,2
)
select * from cte;
select * from foo;
drop table foo;
select cast(NULL as numeric(38,10));
create table foo as WITH cte AS 
(
select cast(cast('' as char(10)) as numeric(38,10)) as [ cast( cast('' as char(10)) as numeric(38,10))]
)
select * from cte;
describe foo;
drop table foo;
create table foo as WITH cte AS
(
select cast(NULL as numeric(38,10)) as [ cast(null as numeric(38,10))]
)
select * from cte;
describe foo;

drop table foo;
create table foo as select * from 
(
select cast(cast('' as char(10)) as numeric(38,10))
) cte;
describe foo;


drop table foo;
create table t1(
c_short short,
c_int int,
c_bigint bigint,
c_date date,
c_time time,
c_timestamp timestamp,
c_datetime datetime,
c_timestampltz timestamp with local time zone,
c_timestamptz timestamp with time zone,
c_datetimeltz datetime with local time zone,
c_datetimetz datetime with time zone
);

insert into t1 values(
10, 99, 123456789,
date'2020-12-12', time'23:59:59', timestamp'1999-04-23 14:35:56', datetime'1999-04-23 14:35:56.789',
timestampltz'2033-10-01 12:13:14 -12:00', timestamptz'2033-10-01 12:13:14 Europe/Riga',
datetimeltz'1823-12-31 23:59:59 +14:00', datetimetz'2099-11-23 12:00:00 AM Australia/Eucla'
);

select REPEAT( c_date, c_bigint ) from t1;

drop table if exists foo;
create table foo as WITH cte AS
(
select REPEAT( c_time, c_bigint ) as a from t1
)
select * from cte;
describe foo;

drop table if exists foo;
create table foo as select * from (select REPEAT( c_time, c_bigint ) as a from t1) cte;
describe foo;


drop table if exists foo;
create table foo as WITH cte AS
(
select REPEAT( c_time, c_int ) as [repeat( cast(t1.c_time as varchar), t1.c_int)] from t1
)
select * from cte;
select * from foo order by 1;
drop if exists tb1,tb2,foo,t1;
