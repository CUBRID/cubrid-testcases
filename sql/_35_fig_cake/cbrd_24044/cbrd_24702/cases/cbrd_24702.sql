-- This scenario verifies CBRD-24702 issue.
-- 'SAMPLING_SCAN' SQL hint is added — check plan/statistics via SHOW TRACE only (no aggregate row assertions).

drop table if exists t;
create table t (col_a int, col_b int, col_c int, col_d varchar(20), col_e numeric(20,10), col_f varchar(20), col_g varchar(20), col_h varchar(20));
insert into t select rownum, rownum/20,1, lpad(to_char(rownum/1000),20,'0'), rownum/100000, lpad(to_char(rownum/10000),20,'0'), lpad(to_char(rownum/100),20,'0'), lpad(to_char(rownum/10),20,'0')
from db_class a, db_class b, db_class c, db_class d 
limit 1000000;

update statistics on t;

set trace on;

select /*+ recompile sampling_scan */ 1 as c
from t
limit 1;
show trace;

--partition table
drop table if exists t;
create table t (col_a int, col_b int, col_c int, col_d varchar(20), col_e numeric(20,10), col_f varchar(20), col_g varchar(20), col_h varchar(20)) 
PARTITION BY HASH (col_a) PARTITIONS 4;
insert into t select rownum, rownum/20,1, lpad(to_char(rownum/1000),20,'0'), rownum/100000, lpad(to_char(rownum/10000),20,'0'), lpad(to_char(rownum/100),20,'0'), lpad(to_char(rownum/10),20,'0') 
from db_class a, db_class b, db_class c, db_class d 
limit 1000000;

update statistics on t;

select /*+ sampling_scan */ 1 as c
from t
limit 1;
show trace;

set trace off;

drop table t;
