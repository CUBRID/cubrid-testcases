drop table if exists t1;

create table t1(a int, b date, c nchar, d enum('red','yellow','blue','green'));

insert into t1 values(1,'2013-1-2',n'h',1);

insert into t1 values(1,'2013-1-2',n'hello',1);

insert into t1 values(2,'2013-12-2',n'Welcome',2);

insert into t1 values(2,'2013-10-12',n'welcome',2);

insert into t1 values(2,'2013-10-12',n'welcome',3);

insert into t1 select * from t1;

insert into t1 select * from t1;

insert into t1 select * from t1;

insert into t1 select * from t1;

insert into t1 select * from t1;

insert into t1 select * from t1;

insert into t1 select * from t1;

insert into t1 select * from t1;

insert into t1 select * from t1;

insert into t1 select * from t1;

insert into t1 select * from t1;

insert into t1 select * from t1;

insert into t1 select * from t1;

insert into t1 select * from t1;

---insert into t1 select rownum, '2013-10-12',n'welcome',3 from db_class a, db_class b, db_user c limit 3528;
insert into t1 select rownum, '2013-10-12',n'welcome',3 from  db_root connect by level <= 3528;

set trace on;

WITH cte_6I00nizhY AS
(
select a, max(b) from (select * from t1 order by 1,2,3,4) group by d
)
select * from cte_6I00nizhY order by 1, 2;

show trace;

WITH cte_6I00nizhY AS
(
select a, max(b) from (select * from t1 order by 1,2,3,4) group by d
)
select count(*) from cte_6I00nizhY;

show trace;

WITH cte_6I00nizhY AS
(
select a, max(b) from (select * from t1 order by 1,2,3,4) group by d
)
, cte_1110 as (select count(*) from cte_6I00nizhY) select * from cte_1110;

show trace;
drop table if exists t1;
