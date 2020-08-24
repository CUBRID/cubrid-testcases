set system parameters 'create_table_reuseoid=no';
--delete tablename
create table bug_6547(id int);
insert into bug_6547 values(1);
delete bug_6547;

--delete tablename where...
insert into bug_6547 values(1);
insert into bug_6547 values(21);
delete bug_6547 where id=21;

--delete viewname
insert into bug_6547 values(1);
create view vbug_6547 as select * from bug_6547;
delete vbug_6547;

--delete viewname where...
insert into bug_6547 values(1);
insert into bug_6547 values(21);
delete vbug_6547 where id=21;
select * from vbug_6547;


--delete indexname
create index idx on bug_6547(id);
delete idx;
drop index idx on bug_6547;

--delete tablename from tablename
insert into bug_6547 values(1);
delete bug_6547 from bug_6547;
select * from vbug_6547;

--delete columnname from tablename
insert into bug_6547 values(1);
delete id from bug_6547;

--delete from tablename
insert into bug_6547 values(1);
delete from bug_6547;

drop vbug_6547;
drop bug_6547;
set system parameters 'create_table_reuseoid=yes';
