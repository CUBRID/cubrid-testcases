drop table if exists t35;
create table t35 (a DATETIME default SYSDATETIME, b DATETIME default SYSDATETIME);
insert into t35 (a) values (default);
select if (a = b, 'ok', 'nok') from t35;

drop table if exists t35;
create table t35 (a DATETIME default current_datetime, b DATETIME default current_datetime);
insert into t35 (a) values (default);
select if (a = b, 'ok', 'nok') from t35;

drop table if exists t35;
create table t35 (a DATETIME default systimestamp, b DATETIME default systimestamp);
insert into t35 (a) values (default);
select if (a = b, 'ok', 'nok') from t35;

drop table if exists t35;
create table t35 (a DATETIME default current_timestamp, b DATETIME default current_timestamp);
insert into t35 (a) values (default);
select if (a = b, 'ok', 'nok') from t35;

--current_time/sys_time not support consistent value
--drop table if exists t35;
--create table t35 (a TIME default current_time, b TIME default current_time);
--insert into t35 (a) values (default);
--select if (a = b, 'ok', 'nok') from t35;

--drop table if exists t35;
--create table t35 (a TIME default sys_time, b TIME default sys_time);
--insert into t35 (a) values (default);
--select if (a = b, 'ok', 'nok') from t35;

select typeof(sys_time),typeof(current_time),typeof(sys_timestamp),typeof(current_timestamp),typeof(sys_datetime),typeof(current_datetime),
typeof(sys_date),typeof(current_date);

drop table if exists t35;
