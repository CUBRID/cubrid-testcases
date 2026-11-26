-- CBRD-28173: per-row partition pruning of a nested-loop inner must read a join term whose partition key is on the right with the operator commuted
drop table if exists t28173_p, t28173_n, t28173_y;

create table t28173_p (id int, a int, b int) partition by range (a)
  (partition p0 values less than (3), partition p1 values less than (6), partition p2 values less than maxvalue);
insert into t28173_p select rownum, mod (rownum, 9), mod (rownum, 10) from db_class c1, db_class c2 where rownum <= 900;
create index i28173_p_a on t28173_p (a);

-- the same rows without partitions: the expected results
create table t28173_n (id int, a int, b int);
insert into t28173_n select * from t28173_p;
create index i28173_n_a on t28173_n (a);

create table t28173_y (id int, a int, b int);
insert into t28173_y select rownum, mod (rownum, 9), mod (rownum * 3, 10) from db_class where rownum <= 60;

update statistics on t28173_p, t28173_n, t28173_y with fullscan;

-- 1. outer join, partition key on the right of the range term
select /*+ ORDERED USE_IDX */ count(*), count(y.id) from t28173_n x left outer join t28173_p y on x.a = y.a and x.b > y.a;
select /*+ ORDERED USE_IDX */ count(*), count(y.id) from t28173_n x left outer join t28173_p y on x.a = y.a and x.b >= y.a;
select /*+ ORDERED USE_IDX */ count(*), count(y.id) from t28173_n x left outer join t28173_p y on x.a = y.a and x.b < y.a;
select /*+ ORDERED USE_IDX */ count(*), count(y.id) from t28173_n x left outer join t28173_p y on x.a = y.a and x.b <= y.a;
select /*+ ORDERED USE_IDX */ count(*), count(y.id) from t28173_n x left outer join t28173_n y on x.a = y.a and x.b > y.a;

-- 2. outer join, partition key on the left: the same results as 1
select /*+ ORDERED USE_IDX */ count(*), count(y.id) from t28173_n x left outer join t28173_p y on x.a = y.a and y.a < x.b;
select /*+ ORDERED USE_IDX */ count(*), count(y.id) from t28173_n x left outer join t28173_p y on x.a = y.a and y.a <= x.b;
select /*+ ORDERED USE_IDX */ count(*), count(y.id) from t28173_n x left outer join t28173_p y on x.a = y.a and y.a > x.b;
select /*+ ORDERED USE_IDX */ count(*), count(y.id) from t28173_n x left outer join t28173_p y on x.a = y.a and y.a >= x.b;

-- 3. inner join, partition key on the right of the range term
select /*+ ORDERED USE_IDX */ count(*) from t28173_y y, t28173_p x where x.a = y.a and y.b >= x.a;
select /*+ ORDERED USE_IDX */ count(*) from t28173_y y, t28173_p x where x.a = y.a and y.b > x.a;
select /*+ ORDERED USE_IDX */ count(*) from t28173_y y, t28173_p x where x.a = y.a and y.b <= x.a;
select /*+ ORDERED USE_IDX */ count(*) from t28173_y y, t28173_p x where x.a = y.a and y.b < x.a;
select /*+ ORDERED USE_IDX */ count(*) from t28173_y y, t28173_n x where x.a = y.a and y.b >= x.a;

-- 4. nested-loop join without the index
select /*+ ORDERED USE_NL */ count(*), count(y.id) from t28173_n x left outer join t28173_p y on x.a = y.a and x.b > y.a;
select /*+ ORDERED USE_NL */ count(*) from t28173_y y, t28173_p x where x.a = y.a and y.b >= x.a;

drop table t28173_p, t28173_n, t28173_y;
