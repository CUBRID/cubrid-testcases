create serial s_1;

drop table if exists t1,t2;

create table t1(a set(int, char(1)),b multiset(char(2), smallint),c list(timestamp, bigint), d sequence(varchar, datetime));
insert into t1 values({1, 2, 3}, {1, 1, 3, 'a'}, {'1990-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
create table t2(a set(int, char(1)),b multiset(char(2), smallint),c list(timestamp, bigint), d sequence(varchar, datetime));
insert into t2 values({1, 2, 3}, {1, 1, 3, 'a'}, {'1990-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});


merge into t2
using t1
on (t1.a=t2.a)
when matched then
update
set t2.b=t1.b;

merge into t2
using t1
on (t1.a!=t2.a)
when matched then
update
set t2.b=t1.b;


drop table t1,t2;







drop table if exists t1,t2;
CREATE TABLE t1 (a varchar(200),b varchar(200),c short );
INSERT INTO t1 VALUES ('aaabbb','aaabbb',1), ('aaa%','aaa%',2);
CREATE TABLE t2 (a varchar(200),b varchar(200),c short);
INSERT INTO t2 VALUES ('aaabbb','aaabbb',1), ('aaa%','aaa%',2);

merge into t2
using t1
on (t1.a!=t2.a)
when matched then
update
set t2.b=t1.b
when not matched then
insert
values(t1.a, t1.b,t1.c)
where t2.a is  null;


merge into t2
using t1
on (t1.a=t2.a)
when matched then
update
set t2.b=t1
when not matched then
insert
values(t1.a, t1.b,t1.c)
where t2.a is  null;


merge into t2
using t1
on (t1.a=t2.a)
when matched then
update
set t2.b=t1.a
when not matched then
insert
values(t1.a, t1.b,t1.c)
where t2.c in (2);

merge into t2
using  t1
on  (t1.a=t2.a) 
when matched then
update
set t2.b=t1.a
when not matched then
insert
values(t1.a, s_1.next_value,t1.c) 
where t1.a<100;


merge into t2
using  t1
on  (t1.a=t2.a) 
when matched then
update
set t2.b=t1.a
when not matched then
insert
values(t1.a, s_1.next_value,t1.c) 
where t1.a>100;

drop table t1,t2;






drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
CREATE TABLE t1 (a int primary key,b int,c int );
INSERT INTO t1 VALUES (1,1,1);
INSERT INTO t1 VALUES (2,2,2);
CREATE TABLE t2 (a int primary key ,b int,c int );
INSERT INTO t2 VALUES (1,1,1);
INSERT INTO t2 VALUES (2,2,2);
CREATE TABLE t3 (a int primary key,b int,c int );
INSERT INTO t3 VALUES (1,1,1);
INSERT INTO t3 VALUES (2,2,2);

merge into t2
using t1
on (t1.a=t2.a)
when matched then
update
set t2.b=t1.a
when not matched then
insert
values(t1.a, t1.b,t1.c)
where t2.c in (2);

merge into t2
using t1
on (t1.a=t2.a)
when matched then
update
set t2.b=t1.a
when not matched then
insert
values(t1.a, t1.b,t1.c);

merge into t2
using t1
on ((t1.a=t2.a)<>0 || (t1.a!=t2.a))<>0
when matched then
update
set t2.b=-1
when not matched then
insert
values(t1.a, t1.b,t1.c) ;

merge into t2
using t1
on ((t1.a=t2.a) && (t1.a!=t2.a))
when matched then
update
set t2.b=-1
when not matched then
insert
values(t1.a, t1.b,t1.c) ;

merge into t2
using t1
on ((t1.a=t2.a) && (t1.a!=t2.a))
when matched then
update
set t2.b=-1
when not matched then
insert
values(999999999999999,-999999999999999,999999999999999) ;

merge into t2
using t1
on (t1.a=t2.a) 
when matched then
update
set t2.a=999999999999999,t2.b=999999999999999;

merge into t2
using t1
on (t1.a=t2.a) 
when matched then
update
set t2 = truncat t2;

merge into t2
using (select t1.* from t1,t1 as t2 where t1.a=t2.a and t1.a<1000) t1
on  (t1.a=t2.a) 
when matched then
update
set t2.b=-1
when not matched then
insert
values(t1.a, t1.b,t1.c) ;

merge into t2
using ((select t1.* from t1,t3 as t3 where t1.a=t3.a and t3.a<1000) union all(select t1.* from t1,t1 as t2 where t1.a=t2.a and t1.a<1000)) t1
on  (t1.a=t2.a) 
when matched then
update
set t2.b=-1
when not matched then
insert
values(t1.a, t1.b,t1.c) ;

merge into t2
using ((select t1.* from t1,t3 as t3 where t1.a=t3.a and t3.a<1000) union all (select t1.* from t1,t1 as t2 where t1.a=t2.a and t1.a<1000)) t1
on  (t1.a=t2.a) 
when matched then
update
set t2.b=-1
when not matched then
insert
values(t1.a, t1.b,t1.c) 
where t1.a>1000;

merge into t2
using ((select t1.* from t1,t3 as t3 where t1.a=t3.a and t3.a<1000) union all (select t1.* from t1,t1 as t2 where t1.a=t2.a and t1.a<1000)) t1
on  (t1.a=t2.a) 
when matched then
update
set t2.b=-1
when not matched then
insert
values(t1.a, t1.b,t1.c) 
where t1.a!=t2.a;

merge into t2
using  t1
on  (t1.a=t2.a) 
when matched then
update
set t2.b=-1
when not matched then
insert
values(t1.a, t1.b,t1.c) 
where t2.a>100;

--TBD: there is an issue CUBRIDSUS-9234
--merge into t2
--using  t1
--on  (t1.a=t2.a) 
--when matched then
--update
--set t2.b=s_1.next_value+1,t2.c=s_1.next_value+1;


merge into t2
using  t1
on  (t1.a=t2.a) 
when matched then
update
set t2.b=t1.a
when not matched then
insert
values(t1.a, s_1.next_value,t1.c) 
where t1.a<100;

drop table if exists t1,t2;
create table t1 (a int primary key, b int, c int, d char(10),e char(100),f char(500),index i_t1_b(b)) ;
create table t2 (a int, b int, c int, d char(10),e char(100),f char(500),index i_t1_b(b), primary key(a, b)) partition by hash(b) partitions 3; 
insert into t1 select rownum,rownum, rownum, rownum||'', rownum||'', rownum||'' from db_class c1, db_class c2, db_class c3 limit 10000;
insert into t2 select rownum,rownum, rownum, rownum||'', rownum||'', rownum||'' from db_class c1, db_class c2, db_class c3 limit 10000;
select count(*) from t2;
merge into t2 using  t1 on  (t1.a=t2.a) when matched then update set t2.b=t1.a+1,t2.c=t1.c,t2.d=t1.d;
ALTER TABLE t2 COALESCE PARTITION 2;
select count(*) from t2;

drop table t3;
drop table t2;
drop table t1;
drop serial s_1;
