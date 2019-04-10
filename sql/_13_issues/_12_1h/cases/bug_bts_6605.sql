 
drop table if exists t1;
create table t1 (a int, b int);
insert into t1 values (1,1), (2,2),(3,3),(4,4);
set @tmp=100;
--please check below sql.
update t1 set b=(@tmp:=@tmp+1) order by a desc;
--please verify result after updated. We expect the same updated order with MySQL.
select * from t1 order by a desc;

drop table if exists t1,t2;
create table t1 (a int, b int);
insert into t1 select rownum ,rownum from db_class a,db_class b limit 1000;
create table t2 (a int, b int);
insert into t2 select rownum ,rownum from db_class a,db_class b limit 1000;
set @tmp=100;
--please check below sql.
update t1 set b=(@tmp:=@tmp+1) order by a desc;
--please verify result after updated. We expect the same updated order with MySQL.
select * from t1 order by a desc;
update t2 set b=(@tmp:=@tmp+1) order by a desc;
select * from t2 order by a desc;

drop table if exists t,t1,t2;
-- set up tables
create table t (a int, b varchar(128), c float, u_a int, u_b varchar(128), u_c float);
insert into t values (1, 'a', 0.1, NULL, NULL, NULL);
insert into t values (2, 'b', 0.2, NULL, NULL, NULL);
insert into t values (3, 'c', 0.3, NULL, NULL, NULL);
insert into t values (4, 'd', 0.4, NULL, NULL, NULL);

-- SELECT
-- no rewrite (no ORDER BY)
set @a = 0;
select /*+ recompile */ a, @a := @a + 1 from t order by a;

-- rewrite
set @a = 0;
select /*+ recompile */ a, @a := @a + 1 from t order by a desc;

-- rewrite
set @a = 0;
select a, @a := @a + 1 from t order by 1 desc;

-- no rewrite (ORDER BY order dependent column)
set @a = 0;
select /*+ recompile */ a, @a := @a + 1 from (select * from t order by a) order by 2 desc,1;

-- no rewrite (not in select list)
set @a = 0;
select /*+ recompile */ a, b from (select * from t order by a) where (@a := @a + 1) > 2 order by a,b;

-- rewrite with two ODN
set @a = 0;
set @b = '';
select a, b, @a := @a + 1, @b := @b + cast(a as varchar(100)) + b from (select * from t order by a desc) order by a desc;

-- rewrite with subexpressions
set @a = 0;
select /*+ recompile */ a, @a := (@a + (a + a) / (a * 2)) * (c * 10) + 1 from (select * from t order by a desc) order by a desc;

-- rewrite with functions
set @a = 0;
select /*+ recompile */ a, @a := @a + if(@a < 2, 1, (a * 2) / a) from (select * from t order by a desc) order by a desc;

-- rewrite with functions 2
set @a = 0;
select /*+ recompile */ a, @a := @a + coalesce(if(@a < 2, NULL, a), a * 10, a / 2) from (select * from t order by a desc) order by a desc;

-- rewrite (dependent variables)
set @a = 0;
set @b = 0;
select /*+ recompile */ a, @a := @a + 1, @b := @a * (a - 1) from (select * from t order by a desc) order by a desc;

-- rewrite (hidden columns)
set @a = 0;
select /*+ recompile */ @a := @a + 1 from t order by a desc, b, c;

-- rewrite (only column)
set @a = 0;
select /*+ recompile */ @a := @a + 1 from t order by a desc;

-- rewrite (order by ... limit)
set @a = 0;
select /*+ recompile */ @a := @a + 1 from t order by a desc limit 2;

-- rewrite (subselect, diff correlation)
set @a = 0;
select /*+ recompile */ b, (select @a := @a + a from (select * from t order by a) where b = tt.b order by a desc) from (select * from t order by a) tt order by 1,2;

-- rewrite (subselect, same correlation)
set @a = 0;
select /*+ recompile */ b, (select @a := @a + a from (select * from t order by a desc) order by a desc limit 1) from (select * from t order by a) tt order by 1,2; 

-- rewrite (subselect, same correlation, second level)
set @a = 0;
select /*+ recompile */ b, (select (select @a := @a + a from (select * from t order by a desc) order by a desc limit 1) from (select * from t order by a desc) where tt.b = b) from (select * from t order by a) tt order by 1,2;

-- no rewrite (union, diff correlation)
set @a = 0;
select /*+ recompile */ b, (select @a := @a + a from (select * from t order by a) where b = tt.b union select NULL from (select * from t order by a) where a > 100 order by 1 desc) from (select * from t order by a) tt order by 1,2;

-- no rewrite (union, same correlation)
set @a = 0;
select /*+ recompile */ b, (select @a := @a + a from t union select @a := @a + a from t order by 1 desc limit 1) from t tt order by 1,2;

-- no rewrite (union)
set @a = 0;
select /*+ recompile */ a, @a := @a + 1 from (select * from t order by a) union select a + 2, @a := @a + 1 from (select * from t order by a ) order by a desc,2;

-- rewrite (name clash)
set @a = 0;
select /*+ recompile */ a as ex_0, a as sx_0, b + 'xx' as sx_1, @a := @a + a*2 from (select * from t order by a desc) order by a desc;

-- rewrite (name clash 2)
set @a = 0;
select /*+ recompile */ dt_sort.a, @a := @a + dt_sort.a from (select * from t order by a desc) dt_sort, t t2 order by dt_sort.a desc;

-- rewrite (joins)
set @a = 0;
select /*+ recompile */ t1.a, x.a, @a := @a + 1 from (select * from t order by a) t1 inner join t t2 on t1.a = t2.a left join (select a + 1 as a, @a := @a + 1 from t order by a) x on t2.a = x.a order by 1,2,3;

-- rewrite (two subqueries, same corr level)
set @a = 0;
select /*+ recompile */ b, (select @a := @a + a from (select * from t order by a desc) order by a desc limit 1), (select @a := @a + a from (select * from t order by a desc) order by a desc limit 1) from (select * from t order by a) tt order by 1,2;

-- rewrite (group by)
create table u (a int, b int);
insert into u select a, a from t;
insert into u select a, a + 2 from t;

set @a = 0;
select /*+ recompile */ a, @a := @a + 1 from (select * from u order by a desc) group by a order by a desc;

set @a = 0;
select /*+ recompile */ b, @a := @a + 1 from (select * from u order by b desc) group by b order by b desc;

-- rewrite (derived table)
set @a = 0;
select /*+ recompile */ a, b, @a := @a + 1 from (select t1.a + 2 as a, t1.a + 4 as b from (select * from t order by a desc) t1) x order by b desc;

-- rewrite (derived table 2)
set @a = 0;
select /*+ recompile */ x + 1, y + 2 from (select a as x, (@a := @a + 1) as y from t order by x desc) z;

-- UPDATE
-- single table update
set @a = 0;
update t set u_a = (@a := @a + 1) order by a desc;
select /*+ recompile */ a, u_a from t order by a;

-- cleanup
drop variable @a,@b,@tmp;
drop t, u;

