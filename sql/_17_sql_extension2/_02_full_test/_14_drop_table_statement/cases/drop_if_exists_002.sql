--drop multiple tables using 'if exists' condition


drop table if exists drop_test1;


create table drop_test1(a int);
insert into drop_test1 values(1), (32), (-12312);
select * from drop_test1 order by 1;

drop table if exists drop_test2;
create table drop_test2(a int);
insert into drop_test2 values(1), (32), (-12312);
select * from drop_test2 order by 1;

drop table if exists drop_test3;
create table drop_test3(a int);
insert into drop_test3 values(1), (32), (-12312);
select * from drop_test3 order by 1;

drop table if exists drop_test4;
create table drop_test4(a int);
insert into drop_test4 values(1), (32), (-12312);
select * from drop_test4 order by 1;

drop table if exists drop_test5;
create table drop_test5(a int);
insert into drop_test5 values(1), (32), (-12312);
select * from drop_test5 order by 1;


drop table if exists drop_test, drop_test1, drop_test2, drop_test3, drop_test4, drop_test5;
