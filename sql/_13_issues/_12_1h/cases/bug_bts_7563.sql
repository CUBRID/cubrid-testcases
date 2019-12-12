--[Multi-table Update] ERROR: System error (generate attr) in /home1/build/workspace/trunk/src/parser/xasl_generation.c (line: 9456) occurs when updating 2 tables with left outer join


--server side
create table md_double1(id1 int, col1 timestamp not null);
insert into md_double1 values(1, '2011-09-01 12:12:12');
insert into md_double1 values(2, '2011-09-01 12:12:12');
insert into md_double1 values(2, '2011-09-01 12:12:12');
insert into md_double1 values(3, '2011-09-01 12:12:12');

create table md_double2(col1 varchar(1024), id2 int);
insert into md_double2 values('aaa', 1);
insert into md_double2 values('aaa', 2);

update md_double2 m2 left outer join md_double1 m1 on m1.id1=m2.id2 set m1.id1=m2.id2, m1.col1=SYSTIMESTAMP;

select if((SYSTIMESTAMP-col1) < 2, 'ok', 'nok') from md_double1 where id1 in (select id2 from md_double2);

drop table md_double1, md_double2;



--client side
create table md_double1(id1 int, col1 timestamp not null);
insert into md_double1 values(1, '2011-09-01 12:12:12');
insert into md_double1 values(2, '2011-09-01 12:12:12');
insert into md_double1 values(2, '2011-09-01 12:12:12');
insert into md_double1 values(3, '2011-09-01 12:12:12');

create table md_double2(col1 varchar(1024), id2 int);
insert into md_double2 values('aaa', 1);
insert into md_double2 values('aaa', 2);

create table t(a int primary key auto_increment);
create trigger trigg before update on md_double1 execute insert into t default;

update md_double2 m2 left outer join md_double1 m1 on m1.id1=m2.id2 set m1.id1=m2.id2, m1.col1=SYSTIMESTAMP;

select if((SYSTIMESTAMP-col1) < 2, 'ok', 'nok') from md_double1 where id1 in (select id2 from md_double2);
select if(count(*)=3, 'ok', 'nok') from t;

drop trigger trigg;
drop table md_double1, md_double2, t;
