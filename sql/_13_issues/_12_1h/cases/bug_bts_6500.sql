set system parameters 'create_table_reuseoid=no';
--Throw "ERROR: System error (generate xasl) in ../../src/parser/xasl_generation.c (line: 14687)" when delete a view from multiple objects.

autocommit off;

--repro case
create table t1(col1 int);
create table t2 (col1 int);
create view v1 as select * from t1;
create view v2 as select * from v1;

delete v2 from v2,t2 where (select max(col1) from v1) > 0 and v2.col1 = t2.col1;

drop t1, t2, v1, v2;


--other test cases
create table t1(a int, b char(10));
insert into t1 values(1, 'aaa');
insert into t1 values(1, 'aaa');
insert into t1 values(2, 'bbb');
insert into t1 values(2, 'ccc');
insert into t1 values(3, 'ddd');
create table t2 (a int, b char(10));
insert into t2 values(1, 'aaa');
insert into t2 values(2, 'bbb');
create view v1 as select * from t1 where a<4;
create view v2 as select * from t2 where b in ('aaa', 'bbb');

commit;

--delete from 2 views
delete v2 from v1,v2 where (select max(a) from v2) > 0 and v1.a = v2.a;
select * from t1 order by 1;
select * from t2 order by 1;
rollback;
delete v1.*, v2 from v1, v2 where (select max(a) from v1) < 8 and v1.b=v2.b;
select * from t1 order by 1;
select * from t2 order by 1;
rollback;

--delete from 1 view and 1 table
delete v1, t2 from v1, t2 where (select max(a) from t2) > 1 and v1.a=t2.a;
select * from t1 order by 1;
select * from t2 order by 1;
rollback;
delete t1.*, v2 from t1, v2 where (select max(a) from v2) < 8 and t1.b=v2.b;
select * from t1 order by 1;
select * from t2 order by 1;
rollback;


--delete from 2 tables
delete t1, t2 from t1, t2 where (select max(a) from t2) > 1 and t1.a=t2.a;
select * from t1 order by 1;
select * from t2 order by 1;
rollback;


--delete from 2 derived views
create view v3 as select * from v2;
create view v4 as select * from v1 where a < 5;
commit;
delete v3 from v3 left outer join v4 on v3.a=v4.a where (select max(b) from v3) < 'eee';
select * from t1 order by 1;
select * from t2 order by 1;
rollback;
--delete from 3 views
delete v1, v3 from v1, v2, v3 where (select min(a) from v3) > 0 and v1.a=v2.a and v1.a=v3.a;
select * from t1 order by 1;
select * from t2 order by 1;
rollback;
--delete from 4 views
delete v2, v4, v3, v1 from v1, v2, v3, v4 where (select min(b) from v4) < 'ddd' and v1.a=v2.a and v3.b=v1.b and v1.a=v4.a;
select * from t1 order by 1;
select * from t2 order by 1;


drop table t1, t2;
drop view v1, v2, v3, v4;


commit;

autocommit on;
set system parameters 'create_table_reuseoid=yes';
