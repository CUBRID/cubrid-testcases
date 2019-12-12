drop table if exists t1;
drop table if exists t2;
create table t1(a int, b clob);
insert into t1 values(1, 'a');
insert into t1 values(2, 'b');
insert into t1 values(3, 'c');

create table t2(a int, b clob);
insert into t2 values(1, 'a');
insert into t2 values(2, 'b');
insert into t2 values(3, 'c');

--@queryplan
select /*+ recompile */ t1.a, clob_to_char(t1.b), clob_to_char(t2.b) from (select * from t1) t1, t2 where clob_to_char(t1.b)=clob_to_char(t2.b) order by 1;
--@queryplan
select /*+ recompile */ t1.a, clob_to_char(t1.b), clob_to_char(t2.b) from (select a, b from t1) t1, t2 where clob_to_char(t1.b)=clob_to_char(t2.b) order by 1;
drop table if exists t1;
drop table if exists t2;
