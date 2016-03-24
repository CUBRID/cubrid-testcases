--+ holdcas on;

drop table if exists test;
create table test (id int primary key, name string);
insert into test values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
 
--good result
delete test from test inner join (values(1),(2)) as t(id) on test.id=t.id;
select * from test order by 1,2;
delete from test;
 
insert into test values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
--error result
delete test from test natural join (values(1),(2)) as t(id);
select * from test order by 1,2;
drop table if exists test;

--test cases from testcase.rar
------ update ----
drop table if exists test;
create table test (id int , name char(20));
insert into test values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
update test natural join (values(1),(2)) as t(id) set test.id=5 ;
select * from test order by 1 desc,2 desc;
delete from test;

------ delete ---
drop table if exists test;
create table test (id int , name char(20));
insert into test values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
delete test from test natural join (values(1),(2)) as t(id);
select * from test order by 1,2;
delete from test;
drop table if exists test;

------- subquery ----
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;

create table t1 ( a int, b int); 
create table t2 ( a int, b int);
create table t3 ( a int, b int);

insert into t1 values(1, 1);
insert into t1 values(2, 2);

insert into t2 values(1, 3);
insert into t2 values(2, 4);

insert into t3 values(1, 9);
insert into t3 values(2, 8);
insert into t3 values(3, 7);
insert into t3 values(4, 6);

update t1 natural join t2 set t1.b = 100;
select * from t1 order by 1,2;

update t1 natural join (select a, b as bxx from t2) set t1.b = 100;
select * from t1 order by 1,2;

delete t1 from t1 natural join (select a, b as bxx from t2);
select * from t1 order by 1,2;

insert into t1 values(1, 1);
insert into t1 values(3, 3);

update t1 natural join (select * from t1 difference select * from t3) as tt(a,bxx) set t1.b = 100;
select * from t1 order by 1,2;

drop table if exists t1;
drop table if exists t2;
drop table if exists t3;

--+ holdcas off;
commit;
