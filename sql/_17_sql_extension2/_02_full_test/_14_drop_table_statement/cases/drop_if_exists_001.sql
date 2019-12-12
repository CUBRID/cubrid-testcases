--drop one table using 'if exists' condition


drop table if exists drop_test;


create table drop_test(a int);
insert into drop_test values(1), (32), (-12312);
select * from drop_test order by 1;

drop table if exists drop_test;
create table drop_test(a int);
insert into drop_test values(1), (32), (-12312);
select * from drop_test order by 1;

drop table if exists drop_test;
create table drop_test(a int);
insert into drop_test values(1), (32), (-12312);
select * from drop_test order by 1;

drop table if exists drop_test;
create table drop_test(a int);
insert into drop_test values(1), (32), (-12312);
select * from drop_test order by 1;

drop table if exists drop_test;
create table drop_test(a string);
insert into drop_test values('abc'), ('def');
select * from drop_test order by 1;


drop table if exists drop_test;
