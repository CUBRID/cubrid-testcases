

drop table if exists tbl;
create table tbl (col_a varchar(20), col_b varchar(20), col_c varchar(20), col_d varchar(20), col_e numeric(20,10), col_f varchar(20), col_g varchar(20), col_h varchar(20));
insert into tbl select rownum, 1, mod(rownum,10), lpad(to_char(mod(rownum,100)),20,'0'), mod(rownum,1000), lpad(to_char(mod(rownum,10000)),20,'0'), lpad(to_char(mod(rownum,100000)),20,'0'), lpad(to_char(mod(rownum,100000)),20,'0') from db_class a, db_class b, db_class c, db_class d, db_class f, db_class g limit 100000;
create index idx_a on tbl(col_b,col_c,col_a);
update statistics on tbl;
set trace on;

--Add Selecitivity of index filter scan when calculating data io cost of index scan.
select /*+ recompile */ count(col_d) from tbl where col_b = 1 and col_a = 2;
show trace;
select /*+ recompile */ count(col_d) from tbl where col_b = 1;
show trace;


--Add 'NOT LIKE' selectivity.
SET SYSTEM PARAMETERS 'like_term_selectivity=0.2';
select /*+ recompile */ count(*) from tbl where col_c like '%11%';
show trace;
select /*+ recompile */ count(*) from tbl where col_c not like '%11%';
show trace;

SET SYSTEM PARAMETERS 'like_term_selectivity=0.8';
select /*+ recompile */ count(*) from tbl where col_c like '%11%';
show trace;
select /*+ recompile */ count(*) from tbl where col_c not like '%11%';
show trace;

--Add Function-based index selectivity.
create index idx_b on tbl(nvl(col_g,'12'));
update statistics on tbl;

SET SYSTEM PARAMETERS 'like_term_selectivity=0.001';
select /*+ recompile */ count(*) from tbl where nvl(col_g,'12') = '12';
show trace;

SET SYSTEM PARAMETERS 'like_term_selectivity=0.00001';
select /*+ recompile */ count(*) from tbl where nvl(col_g,'12') = '12';
show trace;



drop table tbl;

set trace off;
SET SYSTEM PARAMETERS 'like_term_selectivity=0.001';
