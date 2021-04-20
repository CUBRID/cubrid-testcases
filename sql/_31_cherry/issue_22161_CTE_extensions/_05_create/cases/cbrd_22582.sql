set system parameters 'create_table_reuseoid=no';
drop table if exists t,foo;
create table t(a int);
insert into t select rownum from db_root connect by level<=10;

create table foo (i int) 
partition by range(i) 
(
 partition p1 values less  than(100),
 partition p2 values less  than(2000)
)  as WITH cte AS
(
select count(t.*) from t
)
select count(*) as [count(*)] from cte;

WITH cte AS
(
select count(t.*) from t
)
select count(*) as [count(*)] from cte;
describe foo;

drop table foo;
create table foo  as
WITH cte AS
(
select count(t.*) from t
)
select count(*) as [count(*)] from cte;
select * from foo order by 1;


drop table foo;
create table foo(i int)  as
WITH cte AS
(
select count(t.*) as cmt from t
)
select count(*) as cnt from cte;
select * from foo order by 1;
drop table if exists t,foo;
set system parameters 'create_table_reuseoid=yes';
