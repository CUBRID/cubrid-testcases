-- CBRD-27381: radix-sorted index builds of TDE-encrypted tables
--
-- An index build of a TDE-encrypted table writes the runs it flushes, and the records too long for a
-- run (written to a file of their own), to encrypted temporary files, and the merge reads them back
-- decrypted. t_r and t_c hold the same rows and are both created with ENCRYPT=AES. Every index of t_r is
-- built with index_sort_method=radix and the same index of t_c with compare, both with
-- index_build_buffer_size 64K so a build flushes several runs. Read in index order, each radix-built
-- index must return the rows of its compare-built twin in the same order (0 rows differ) and find as
-- many rows.
--
-- Rows: 6000 values in four shapes of 1500 (scattered, ascending, descending, few distinct values) with
-- a NULL every 101st row. The BIT VARYING value of every 500th row is about 20KB, longer than a sort
-- record can be. The other BIT VARYING values are 24 bits each and all distinct (values of different
-- lengths could compare equal but for trailing zeros, see 05).
--
-- Covers: BIGINT, VARCHAR(30) utf8_bin, (BIGINT, VARCHAR), BIT VARYING with long values, all in
-- AES-encrypted tables

drop table if exists g;
drop table if exists t_r;
drop table if exists t_c;

create table g (n int, v int);
insert into g
  select n,
         case when mod (n, 101) = 0 then null
              when n <= 1500 then mod (n * 7919, 6007) - 3003
              when n <= 3000 then (n - 1501) * 4 - 3000
              when n <= 4500 then 3000 - (n - 3001) * 4
              else mod (n, 7) * 1000 - 3000 end
  from (select rownum as n from db_class a, db_class b, db_class c limit 6000) x;

create table t_r (id int, k bigint, s varchar(30) collate utf8_bin, b bit varying) encrypt = aes;
create table t_c (id int, k bigint, s varchar(30) collate utf8_bin, b bit varying) encrypt = aes;
insert into t_r
  select n, v * 3037000493, concat (v, substr ('abcd', 1, mod (n, 4))),
         case when mod (n, 500) = 0 then cast (repeat ('ab', 20000 + n) as bit varying)
              else cast (to_char (100000 + n) as bit varying) end
  from g order by n;
insert into t_c select * from t_r order by id;

-- both tables are encrypted
select class_name, tde_algorithm from db_class where class_name in ('t_r', 't_c') order by class_name;

set system parameters 'index_build_buffer_size=64K';
set system parameters 'index_sort_method=radix';
create index i_rk on t_r (k);
create index i_rs on t_r (s);
create index i_rks on t_r (k, s);
create index i_rb on t_r (b);
set system parameters 'index_sort_method=compare';
create index i_ck on t_c (k);
create index i_cs on t_c (s);
create index i_cks on t_c (k, s);
create index i_cb on t_c (b);
set system parameters 'index_sort_method=DEFAULT';
set system parameters 'index_build_buffer_size=DEFAULT';

-- rows read in index order that differ from the compare-built index: 0 each. The BIT VARYING keys are all
-- distinct, so their rows are read with the id. Equal BIGINT and VARCHAR keys lie in OID order, which may
-- differ between the two tables, so those are read as their keys
select 'k', count(*) from ((select rownum, k from t_r where k >= -9223372036854775807 using index i_rk)
  difference (select rownum, k from t_c where k >= -9223372036854775807 using index i_ck)) x;
select 's', count(*) from ((select rownum, s from t_r where s >= '' using index i_rs)
  difference (select rownum, s from t_c where s >= '' using index i_cs)) x;
select 'k, s', count(*) from ((select rownum, k, s from t_r where k >= -9223372036854775807 using index i_rks)
  difference (select rownum, k, s from t_c where k >= -9223372036854775807 using index i_cks)) x;
select 'b', count(*) from ((select rownum, bit_length (b), id from t_r where b >= X'' using index i_rb)
  difference (select rownum, bit_length (b), id from t_c where b >= X'' using index i_cb)) x;

-- rows each radix-built index finds: all but the NULL ones (all 6000 for b)
select count(*) from t_r where k >= -9223372036854775807 using index i_rk;
select count(*) from t_r where s >= '' using index i_rs;
select count(*) from t_r where k >= -9223372036854775807 using index i_rks;
select count(*) from t_r where b >= X'' using index i_rb;

drop table g;
drop table t_r;
drop table t_c;
