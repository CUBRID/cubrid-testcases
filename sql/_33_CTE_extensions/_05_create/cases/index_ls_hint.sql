drop table if exists s1,t1,foo;

create table s1 (a int);

insert into s1 select rownum from db_root connect by level<=40;

create table t1(a int, b int, c int, d int);

insert into t1 (a,b,c,d) select mod(rownum,10), mod(rownum,100), rownum, rownum from s1 x1, s1 x2 limit 1000;

create index idx_t1_abc on t1(a,b,c) with online;

update statistics on t1 with fullscan;

--CTP can not display query plan
--csql correct 
WITH cte(a,min_b,i)  AS
(
select /*+ recompile index_ls */ a, min(b),c from t1 where a>0 group by a order by a
)
select * from cte;

create table foo (i int) 
partition by range(i) 
(partition p1 values less  than(10),
partition p2 values less  than(2000)
)  as WITH cte(a,min_b,i)  AS
(
select /*+ recompile index_ls */ a, min(b),c from t1 where a>0 group by a
)
select * from cte;

select * from foo order by 1,2,3;
select * from foo__p__p2 order by 1,2,3;

 WITH cte(a,min_b,i)  AS
(
select /*+ recompile index_ls */ a, min(b),c from t1 where a>0 group by a
) delete from foo where i=(select max(i) from cte);
select * from foo order by 1,2,3;

 WITH cte(a,min_b,i)  AS
(
select /*+ recompile index_ls */ a, min(b),c from t1 where a>0 group by a
) update foo set i=i-1000 where i=(select median(i) from cte);
select * from foo order by 1,2,3;

insert into foo 
WITH cte(a,min_b,i)  AS
(
select /*+ recompile index_ls */ a, min(b),c from t1 where a>0 group by a
) select * from cte where i=(select min(i) from cte);

replace into foo
WITH cte(a,min_b,i)  AS
(
select /*+ recompile index_ls */ a, min(b),c from t1 where a>0 group by a
) select * from cte where i=(select min(i) from cte);
select * from foo order by 1,2,3;
drop table if exists s1,t1,foo;

