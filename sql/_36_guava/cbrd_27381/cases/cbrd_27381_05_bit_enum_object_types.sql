-- CBRD-27381: radix-sorted index builds of BIT, BIT VARYING, ENUM and object references
--
-- t_r and t_c hold the same rows. Every column of t_r is indexed with index_sort_method=radix and the
-- same column of t_c with compare, both with index_build_buffer_size 64K so a build sorts several
-- runs. Read in index order, each radix-built BIT and BIT VARYING index must return the rows of its
-- compare-built twin in the same order (0 rows differ) and find as many rows. A range does not scan an
-- index of ENUM or of an object reference, so for those each value is looked up through the
-- radix-built index and without an index: no value finds a different count (0).
--
-- Rows: 6000 values in four shapes of 1500 (scattered, ascending, descending, few distinct values)
-- with a NULL every 101st row. The BIT VARYING values differ in length, so values such as X'5',
-- X'50' and X'500' share their bits but for trailing zeros, and the longest ones span many words.
--
-- Covers: BIT(12), BIT(64), BIT VARYING(20), BIT VARYING(1000), BIT VARYING (no precision), ENUM,
-- a reference to a DONT_REUSE_OID table, and a descending index of BIT VARYING(20)

drop table if exists g;
drop table if exists t_r;
drop table if exists t_c;
drop table if exists o_ref;

create table g (n int, v int);
insert into g
  select n,
         case when mod (n, 101) = 0 then null
              when n <= 1500 then mod (n * 7919, 6007) - 3003
              when n <= 3000 then (n - 1501) * 4 - 3000
              when n <= 4500 then 3000 - (n - 3001) * 4
              else mod (n, 7) * 1000 - 3000 end
  from (select rownum as n from db_class a, db_class b, db_class c limit 6000) x;

create table o_ref (n int) dont_reuse_oid;
insert into o_ref select n from g where n <= 300 order by n;

create table t_r (id int, b1 bit(12), b2 bit(64), b3 bit varying(20), b4 bit varying(1000), b5 bit varying,
                  e1 enum('red', 'green', 'blue', 'cyan', 'magenta', 'yellow', 'black', 'white'), o1 o_ref);

insert into t_r
  select n,
         cast (lpad (hex (mod (v + 6006, 4096)), 3, '0') as bit(12)),
         cast (concat (lpad (hex (mod (v * 7 + 30000, 65536)), 4, '0'), lpad (hex (mod (n * 31, 65536)), 4, '0'), '0000',
                       lpad (hex (mod (n, 256)), 2, '0'), 'FF') as bit(64)),
         cast (hex (abs (v)) as bit varying(20)),
         cast (repeat (hex (abs (v) + 1), mod (n, 30) + 1) as bit varying(1000)),
         cast (concat (hex (abs (v)), repeat ('0', mod (n, 5))) as bit varying),
         case when v is null then null else mod (v + 6006, 8) + 1 end,
         (select o from o_ref o where o.n = mod (v + 6006, 300) + 1)
  from g order by n;

create table t_c like t_r;
insert into t_c select * from t_r order by id;

set system parameters 'index_build_buffer_size=64K';
set system parameters 'index_sort_method=radix';
create index i_r1 on t_r (b1);
create index i_r2 on t_r (b2);
create index i_r3 on t_r (b3);
create index i_r4 on t_r (b4);
create index i_r5 on t_r (b5);
create index i_r6 on t_r (e1);
create index i_r7 on t_r (o1);
create index i_r3d on t_r (b3 desc);
set system parameters 'index_sort_method=compare';
create index i_c1 on t_c (b1);
create index i_c2 on t_c (b2);
create index i_c3 on t_c (b3);
create index i_c4 on t_c (b4);
create index i_c5 on t_c (b5);
create index i_c3d on t_c (b3 desc);
set system parameters 'index_sort_method=DEFAULT';
set system parameters 'index_build_buffer_size=DEFAULT';

-- rows read in index order that differ from the compare-built index: 0 each
select 'b1', count(*) from ((select rownum, b1 from t_r where b1 >= X'000' using index i_r1)
  difference (select rownum, b1 from t_c where b1 >= X'000' using index i_c1)) x;
select 'b2', count(*) from ((select rownum, b2 from t_r where b2 >= X'0000000000000000' using index i_r2)
  difference (select rownum, b2 from t_c where b2 >= X'0000000000000000' using index i_c2)) x;
select 'b3', count(*) from ((select rownum, b3 from t_r where b3 >= X'' using index i_r3)
  difference (select rownum, b3 from t_c where b3 >= X'' using index i_c3)) x;
select 'b4', count(*) from ((select rownum, b4 from t_r where b4 >= X'' using index i_r4)
  difference (select rownum, b4 from t_c where b4 >= X'' using index i_c4)) x;
select 'b5', count(*) from ((select rownum, b5 from t_r where b5 >= X'' using index i_r5)
  difference (select rownum, b5 from t_c where b5 >= X'' using index i_c5)) x;
select 'b3 desc', count(*) from ((select rownum, b3 from t_r where b3 >= X'' using index i_r3d)
  difference (select rownum, b3 from t_c where b3 >= X'' using index i_c3d)) x;

-- rows each radix-built index finds: all but the NULL ones. With 0 rows differing above, the same count
-- means the radix-built index holds exactly the rows of its twin
select count(*) from t_r where b1 >= X'000' using index i_r1;
select count(*) from t_r where b2 >= X'0000000000000000' using index i_r2;
select count(*) from t_r where b3 >= X'' using index i_r3;
select count(*) from t_r where b4 >= X'' using index i_r4;
select count(*) from t_r where b5 >= X'' using index i_r5;
select count(*) from t_r where b3 >= X'' using index i_r3d;

-- ENUM and object reference: values whose count through the radix-built index differs from the count without
-- an index (0), and the rows the radix-built index finds
select count(*) from (select distinct e1 from t_c where e1 is not null) d
  where (select count(*) from t_r where e1 = d.e1 using index i_r6) <> (select count(*) from t_c where e1 = d.e1 using index none);
select sum ((select count(*) from t_r where e1 = d.e1 using index i_r6)) from (select distinct e1 from t_c where e1 is not null) d;
select count(*) from o_ref o
  where (select count(*) from t_r where o1 = o using index i_r7) <> (select count(*) from t_r where o1 = o using index none);
select sum ((select count(*) from t_r where o1 = o using index i_r7)) from o_ref o;

drop table g;
drop table t_r;
drop table t_c;
drop table o_ref;
