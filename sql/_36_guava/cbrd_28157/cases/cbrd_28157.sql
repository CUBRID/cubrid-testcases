-- CBRD-28157: moving to the next partition must reset the column caches inside a CASE or IF condition
-- Each query on the partitioned table must return the same result as the same query on the plain copy.

drop table if exists t28157p, t28157q, t28157z;

create table t28157p (id int, a int, b int, c varchar(10), d int) partition by range (a)
  (partition p0 values less than (3), partition p1 values less than (6), partition p2 values less than maxvalue);
create table t28157q (id int, a int, b int, c varchar(10), d int);
create table t28157z (id int primary key, a int, b int);
create index i28157p_b on t28157p (b, a);
create index i28157z_ab on t28157z (a, b);

insert into t28157p select rownum, mod (rownum, 9), mod (rownum * 7, 10), decode (mod (rownum, 3), 0, 'ab', 1, 'w', 'v') || mod (rownum, 5), mod (rownum * 3, 40) from db_class c1, db_class c2 where rownum <= 1200;
insert into t28157q select * from t28157p;
insert into t28157z select rownum, mod (rownum, 6), mod (rownum, 3) - 1 from db_class where rownum <= 60;
update statistics on t28157p, t28157q, t28157z with fullscan;

-- Case 1: CASE with a correlated NOT EXISTS plus another CASE
select count(*) from t28157p x where (case when (x.a = 2 or not exists (select 1 from t28157z z where z.a = x.a and z.b > 0)) then 1 end) = 1 and (case when x.b = 4 then 1 end) = 1;
select count(*) from t28157q x where (case when (x.a = 2 or not exists (select 1 from t28157z z where z.a = x.a and z.b > 0)) then 1 end) = 1 and (case when x.b = 4 then 1 end) = 1;
select a, count(*) from t28157p x where (case when (x.a = 2 or not exists (select 1 from t28157z z where z.a = x.a and z.b > 0)) then 1 end) = 1 and (case when x.b = 4 then 1 end) = 1 group by a order by 1;

-- Case 2: CASE with a constant that is not folded at compile time, aggregate reading a column
select count(*), sum(x.id) from t28157p x where (case when (cast(0 as varchar) = '3' or x.d = 27) then 1 end) = 1;
select count(*), sum(x.id) from t28157q x where (case when (cast(0 as varchar) = '3' or x.d = 27) then 1 end) = 1;

-- Case 3: CASE with LIKE, which failed with an execution error
select count(*), sum(x.id) from t28157p x where (case when (cast(6 as varchar) like '2%' or lower(x.c) like 'ab%') then 1 end) = 1;
select count(*), sum(x.id) from t28157q x where (case when (cast(6 as varchar) like '2%' or lower(x.c) like 'ab%') then 1 end) = 1;

-- Case 4: IF condition
select count(*), sum(x.id) from t28157p x where if (cast(0 as varchar) = '3' or x.d = 27, 1, 0) = 1;
select count(*), sum(x.id) from t28157q x where if (cast(0 as varchar) = '3' or x.d = 27, 1, 0) = 1;

-- Case 5: index key condition plus a CASE data filter
select count(*), sum(x.id) from t28157p x where x.b = 4 and (case when (cast(0 as varchar) = '3' or x.d < 30) then 1 end) = 1;
select count(*), sum(x.id) from t28157q x where x.b = 4 and (case when (cast(0 as varchar) = '3' or x.d < 30) then 1 end) = 1;

-- Case 6: UPDATE and DELETE with a CASE condition
update t28157p x set x.b = x.b + 100 where (case when (cast(0 as varchar) = '3' or x.d = 27) then 1 end) = 1;
update t28157q x set x.b = x.b + 100 where (case when (cast(0 as varchar) = '3' or x.d = 27) then 1 end) = 1;
select count(*), sum(b) from t28157p where b >= 100;
select count(*), sum(b) from t28157q where b >= 100;

delete from t28157p x where (case when (cast(0 as varchar) = '3' or x.d = 14) then 1 end) = 1;
delete from t28157q x where (case when (cast(0 as varchar) = '3' or x.d = 14) then 1 end) = 1;
select count(*), sum(id) from t28157p;
select count(*), sum(id) from t28157q;

-- Case 7: GROUP BY derived table on the partitioned table (CBRD-28158)
delete from t28157p;
insert into t28157p values (597, 8, 1, 'ab2', 14);
insert into t28157p values (598, 1, 3, NULL, 22);
delete from t28157z;
insert into t28157z values (60, 2, 0);
update statistics on t28157p, t28157z with fullscan;
select count(*), sum(x.id)
  from (select a, b, c, d, max(id) id from t28157p group by a, b, c, d) x
 where (case when (x.c like 'w0%' or (x.a in (select z.a from t28157z z where z.b < 23) and x.b < -1)) then 1 end) = 1
   and (case when x.d = 22 then 1 end) = 1;

-- Case 8: a single CASE with a plain column condition
drop table if exists t28157s;
create table t28157s (id int, a int, b int) partition by range (a)
  (partition p0 values less than (10), partition p1 values less than maxvalue);
insert into t28157s select rownum, mod (rownum, 100), mod (rownum, 7) from db_class x, db_class y where rownum <= 2000;
select count(*) from t28157s where b = 1;
select count(*) from t28157s where (case when b = 1 then 1 else 0 end) = 1;

-- Case 9: a comparison on the partition key wrapped in IS NULL
drop table if exists t28157n;
create table t28157n (id int, a int, b int) partition by range (a)
  (partition p0 values less than (3), partition p1 values less than (6), partition p2 values less than maxvalue);
insert into t28157n select rownum, case when mod (rownum, 12) = 0 then null else mod (rownum * 7, 9) end, mod (rownum, 10) from db_class c1, db_class c2 where rownum <= 1200;
select sum(x.id) from t28157n x where x.a is null;
select sum(x.id) from t28157n x where (x.a + 1 = -1) is null;

drop table t28157p, t28157q, t28157z, t28157s, t28157n;
