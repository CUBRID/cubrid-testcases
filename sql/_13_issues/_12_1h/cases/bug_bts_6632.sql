-- CUBRIDSUS-6632 test case
drop table if exists aoo;
create table aoo(a int, b datetime default SYSTIMESTAMP);
insert into aoo(a) values(1);
select if (year(b) = year(SYSTIMESTAMP), 'ok', 'not ok') from aoo;
insert into aoo values(1, default);
select if (year(b) = year(SYSTIMESTAMP), 'ok', 'not ok') from aoo;
drop aoo;

-- CUBRIDSUS-6631 test case
drop table if exists foo;
create table foo(a int, b timestamp default SYSDATE);
insert into foo(a) values(1);
select if (year(b) = year(SYSDATE), 'ok', 'not ok') from foo;
insert into foo values(2, default);
select if (year(b) = year(SYSDATE), 'ok', 'not ok') from foo;
drop foo;

-- other test cases
drop table if exists t11,t12,t13,t14,t15,t16,t17,t18,t19,t21,t22,t23,t24,t25,t26,t31,t32,t33,t34,t35,t36,t41,t42;
create table t11 (a timestamp default CURRENT_TIMESTAMP, b timestamp default CURRENT_TIMESTAMP);
create table t12 (a timestamp default UNIX_TIMESTAMP(), b timestamp default UNIX_TIMESTAMP());
create table t13 (a timestamp default SYSTIMESTAMP, b timestamp default SYSTIMESTAMP);
create table t14 (a timestamp default SYSDATE, b timestamp default SYSDATE);
create table t15 (a timestamp default SYSDATETIME, b timestamp default SYSDATETIME);
create table t16 (a timestamp default now(), b timestamp default now());

create table t21 (a date default CURRENT_TIMESTAMP, b date default CURRENT_TIMESTAMP);
--[er] UNIX_TIMESTAMP() cannot be converted to date and time type
create table t22 (a date default UNIX_TIMESTAMP(), b date default UNIX_TIMESTAMP());
create table t23 (a date default SYSTIMESTAMP, b date default SYSTIMESTAMP);
create table t24 (a date default SYSDATE, b date default SYSDATE);
create table t25 (a date default SYSDATETIME, b date default SYSDATETIME);
create table t26 (a date default now(), b date default now());

create table t31 (a DATETIME default CURRENT_TIMESTAMP, b DATETIME default CURRENT_TIMESTAMP);
--[er] UNIX_TIMESTAMP() cannot be converted to datetime type
create table t32 (a DATETIME default UNIX_TIMESTAMP(), b DATETIME default UNIX_TIMESTAMP());
create table t33 (a DATETIME default SYSTIMESTAMP, b DATETIME default SYSTIMESTAMP);
create table t34 (a DATETIME default SYSDATE, b DATETIME default SYSDATE);
create table t35 (a DATETIME default SYSDATETIME, b DATETIME default SYSDATETIME);
create table t36 (a DATETIME default now(), b DATETIME default now());

create table t41 (a varchar(255) default user, b varchar(255) default user);
create table t42 (a varchar(255) default current_user, b varchar(255) default current_user);

insert into t11 (a) values (default);
select if (a = b, 'ok', 'not ok') from t11;

insert into t12 (a) values (default);
select if (abs(a-b)<=10, 'ok', 'not ok') from t12;

insert into t13 (a) values (default);
select if (a = b, 'ok', 'not ok') from t13;

insert into t14 (a) values (default);
select if (a = b, 'ok', 'not ok') from t14;

insert into t15 (a) values (default);
select if (a = b, 'ok', 'not ok') from t15;

insert into t16 (a) values (default);
select if (a = b, 'ok', 'not ok') from t16;

insert into t21 (a) values (default);
select if (a = b, 'ok', 'not ok') from t21;

insert into t23 (a) values (default);
select if (a = b, 'ok', 'not ok') from t23;

insert into t24 (a) values (default);
select if (a = b, 'ok', 'not ok') from t24;

insert into t25 (a) values (default);
select if (a = b, 'ok', 'not ok') from t25;

insert into t26 (a) values (default);
select if (a = b, 'ok', 'not ok') from t26;

insert into t31 (a) values (default);
select if (a = b, 'ok', 'not ok') from t31;

insert into t33 (a) values (default);
select if (a = b, 'ok', 'not ok') from t33;

insert into t34 (a) values (default);
select if (a = b, 'ok', 'not ok') from t34;

insert into t35 (a) values (default);
select if (a = b, 'ok', 'not ok') from t35;

insert into t36 (a) values (default);
select if (a = b, 'ok', 'not ok') from t36;

insert into t41 (a) values (default);
select if (a = b, 'ok', 'not ok') from t41;

insert into t42 (a) values (default);
select if (a = b, 'ok', 'not ok') from t42;

drop table t11;
drop table t12;
drop table t13;
drop table t14;
drop table t15;
drop table t16;

drop table t21;
drop table t23;
drop table t24;
drop table t25;
drop table t26;

drop table t31;
drop table t33;
drop table t34;
drop table t35;
drop table t36;

drop table t41;
drop table t42;
